﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗаполнитьСоглашениеОбОбменеЭД(ПараметрКоманды, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСоглашениеОбОбменеЭД(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(ПараметрКоманды) Тогда
		ОткрытьФорму("Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПросмотраЭД", Новый Структура("ДокументОснование", ПараметрКоманды));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(НастройкаЭДО);

	АдресХранилища = Неопределено;
	
	ИмяМакета = "ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами";
	МакетИДанныеОбъекта = ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(НастройкаЭДО, ИмяМакета);
	
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	ДанныеОбъекта = МакетИДанныеОбъекта.Данные[НастройкаЭДО][ИмяМакета];
	
	Макет = УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], "");
	Если Макет <> Неопределено Тогда
		Попытка
			ПечатнаяФорма = УправлениеПечатью.ИнициализироватьПечатнуюФорму("",, Макет);
			Если ПечатнаяФорма <> Неопределено Тогда
				// Вывод обычных областей с параметрами.
				Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["Шапка"]);
				УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
				АдресХранилища = УправлениеПечатью.СформироватьДокумент(ПечатнаяФорма);
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
		
	УправлениеПечатью.ОчиститьСсылки(ПечатнаяФорма);
	
	Если АдресХранилища <> Неопределено Тогда
		ПоместитьДанныеСоглашенияВоВременноеХранилище(НастройкаЭДО, АдресХранилища);
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(НастройкаЭДО, ИмяМакета)
	
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаЭДО, "Организация, Контрагент");
	Сторона1 = ПредставлениеЮрФизЛица(РеквизитыНастройки.Организация);
	Сторона2 = ПредставлениеЮрФизЛица(РеквизитыНастройки.Контрагент);
	
	ДанныеОрганизации = Новый Структура;
	ЭлектронноеВзаимодействиеПереопределяемый.ЗаполнитьРегистрационныеДанныеОрганизации(
		РеквизитыНастройки.Организация, ДанныеОрганизации);
	
	Город = "";
	Если ДанныеОрганизации.Свойство("Город", Город) И НЕ ЗначениеЗаполнено(Город)
		И ДанныеОрганизации.Свойство("КодРегиона") И ЗначениеЗаполнено(ДанныеОрганизации.КодРегиона) Тогда
		
		Если ДанныеОрганизации.КодРегиона = "77" // Москва
			ИЛИ ДанныеОрганизации.КодРегиона = "78" // Санкт-Петербург
			ИЛИ ДанныеОрганизации.КодРегиона = "92" // Севастополь
			ИЛИ ДанныеОрганизации.КодРегиона = "99" Тогда // Байконур и иные территории
			
			ОбменСКонтрагентамиПереопределяемый.НазваниеРегиона(ДанныеОрганизации.КодРегиона, Город);
		КонецЕсли;
	КонецЕсли;
	
	Субъект = Новый Структура;
	Субъект.Вставить("НастройкаЭДО", НастройкаЭДО);
	Субъект.Вставить("Город",        Город);
	Субъект.Вставить("Дата",         Формат(ТекущаяДатаСеанса(), "ДЛФ=DD"));
	Субъект.Вставить("Сторона1",     Сторона1);
	Субъект.Вставить("Сторона2",     Сторона2);
	
	Субъекты = Новый Массив;
	Субъекты.Добавить(Субъект);
	
	ИмяМенеджераПечати = "Справочник.СоглашенияОбИспользованииЭД";
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати, ИмяМакета, Субъекты);
	
	Возврат МакетИДанныеОбъекта;
	
КонецФункции

&НаСервере
Процедура ПоместитьДанныеСоглашенияВоВременноеХранилище(НастройкаЭДО, АдресХранилища)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	СтруктураФайла  = Новый Структура;
	СтруктураФайла.Вставить("ИмяФайла",                           "Соглашение об обмене электронными документами.docx");
	СтруктураФайла.Вставить("Наименование",                       "Соглашение об обмене электронными документами");
	СтруктураФайла.Вставить("Расширение",                         "docx");
	СтруктураФайла.Вставить("Размер",                             ДвоичныеДанныеФайла.Размер());
	СтруктураФайла.Вставить("Редактирует",                        Неопределено);
	СтруктураФайла.Вставить("ПодписанЭП",                         Ложь);
	СтруктураФайла.Вставить("Зашифрован",                         Ложь);
	СтруктураФайла.Вставить("ФайлРедактируется",                  Ложь);
	СтруктураФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",        АдресХранилища);
	СтруктураФайла.Вставить("ДатаМодификацииУниверсальная",       ТекущаяУниверсальнаяДата());
	СтруктураФайла.Вставить("ФайлРедактируетТекущийПользователь", Ложь);
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураФайла, Новый УникальныйИдентификатор);
	ОбменСКонтрагентамиСлужебный.ПоместитьПараметрВПараметрыКлиентаНаСервере(НастройкаЭДО, АдресХранилища);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеЮрФизЛица(ЮрФизЛицо)
	
	Результат = "";
	
	Сведения = Новый Структура;
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, Сведения);
	
	Если Сведения.Свойство("ПолноеНаименование") И ЗначениеЗаполнено(Сведения.ПолноеНаименование) Тогда
		Результат = Сведения.ПолноеНаименование;
	Иначе
		Результат = Строка(ЮрФизЛицо);
	КонецЕсли;
	
	Если Сведения.Свойство("ИНН") И ЗначениеЗаполнено(Сведения.ИНН) Тогда
		Результат = Результат + " " + СтрШаблон(НСтр("ru = 'ИНН %1'"), Сведения.ИНН);
		Если Сведения.Свойство("КПП") И ЗначениеЗаполнено(Сведения.КПП) Тогда
			Результат = Результат + " " + СтрШаблон(НСтр("ru = 'КПП %1'"), Сведения.КПП);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
