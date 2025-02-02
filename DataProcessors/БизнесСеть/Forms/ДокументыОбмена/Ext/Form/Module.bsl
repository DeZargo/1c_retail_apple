﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не БизнесСеть.ПравоВыполненияОбменаДокументами(Неопределено, Истина)
		ИЛИ Не БизнесСеть.ПравоЧтенияНастроекОбменаДокументами(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СписокВсехТиповЭД = БизнесСеть.ВидыДокументовСервиса();
	
	Для каждого ЭлементСписка Из СписокВсехТиповЭД Цикл
		Элементы.ОтборВидДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
	Параметры.Свойство("РежимИсходящихДокументов", РежимИсходящихДокументов);
	
	Если РежимИсходящихДокументов Тогда
		НастройкиОтбора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("БизнесСеть",
			"ИсходящиеДокументы\НастройкиОтбора");
			
		Элементы.КомандаЗагрузить.Видимость = Ложь;
		Элементы.КомандаОтклонитьДокументы.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Исходящие документы 1С:Бизнес-сеть'");
		Элементы.ПоказыватьЗагруженные.Заголовок = НСтр("ru = 'Показывать доставленные'");
		Элементы.СписокКонтрагентНаименование.Заголовок = "Получатель";
	Иначе
		Заголовок = НСтр("ru = 'Входящие документы 1С:Бизнес-сеть'");
		НастройкиОтбора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("БизнесСеть",
			"ВходящиеДокументы\НастройкиОтбора");
	КонецЕсли;
	Если ТипЗнч(НастройкиОтбора) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиОтбора);
	КонецЕсли;
	
	ОбновитьСписок(Отказ);
	
	ИспользуетсяНесколькоОрганизацийЭД = ЭлектронноеВзаимодействиеСлужебный.ИспользуетсяНесколькоОрганизаций();
	
	Если Не ИспользуетсяНесколькоОрганизацийЭД Тогда
		Элементы.СписокОрганизация.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОтбора = Новый Структура;
	НастройкиОтбора.Вставить("ВключитьОтборВидДокумента", ВключитьОтборВидДокумента);
	НастройкиОтбора.Вставить("ВключитьОтборКонтрагент", ВключитьОтборКонтрагент);
	НастройкиОтбора.Вставить("ОтборВидДокумента", ОтборВидДокумента);
	НастройкиОтбора.Вставить("ОтборКонтрагент", ОтборКонтрагент);
	НастройкиОтбора.Вставить("ПоказыватьЗагруженные", ПоказыватьЗагруженные);
	
	Если РежимИсходящихДокументов Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("БизнесСеть",
			"ИсходящиеДокументы\НастройкиОтбора", НастройкиОтбора);
	Иначе
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("БизнесСеть",
			"ВходящиеДокументы\НастройкиОтбора", НастройкиОтбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокВходящихДокументов1СБизнесСеть" Тогда
		ОбновитьСписокДокументов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ВключитьОтборКонтрагент = ЗначениеЗаполнено(ОтборКонтрагент);
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтборКонтрагентПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтборВидДокументаПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();

КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ВключитьОтборВидДокумента = ЗначениеЗаполнено(ОтборВидДокумента);
	ОбновитьСписокДокументов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВывестиЭДНаПросмотр(Элементы.Список.ТекущиеДанные)
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередУдалением(Элемент, Отказ)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать документ.'"));
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("УдалитьДокументВСервисеПослеВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Выделенные документы будут удалены в сервисе 1С:Бизнес-сеть.
							  |Документы учета информационной базы не изменятся.
							  |Продолжить выполнение операции?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДанныхТипОбъектаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элементы.СписокТипОбъекта.Очистить();
	
	Для каждого ЗначениеМассива Из Элементы.Список.ТекущиеДанные.ВозможныеТипыОбъекта Цикл
		Элементы.СписокТипОбъекта.Добавить(ЗначениеМассива.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииЯчейки(Элемент)
	
	ДоступностьЗагрузки = Элементы.Список.ВыделенныеСтроки.Количество() <= 1;
	Если ДоступностьЗагрузки <> Элементы.КомандаЗагрузить.Доступность Тогда
		Элементы.КомандаЗагрузить.Доступность            = ДоступностьЗагрузки;
		Элементы.КомандаОтклонитьДокументы.Доступность   = ДоступностьЗагрузки;
		Элементы.КомандаОткрытьПредставление.Доступность = ДоступностьЗагрузки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Возможна загрузка только по одному документу.'"));
		Возврат;
	КонецЕсли;
	
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВывестиЭДНаПросмотр(Список.НайтиПоИдентификатору(ВыделеннаяСтрока), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ВывестиЭДНаПросмотр(Элементы.Список.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДокументы(Команда)
	
	Отказ = Ложь;
	
	СписокФайловВХранилище = Новый Массив;
	
	Для каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		
		СтрокаДанных = Список.НайтиПоИдентификатору(СтрокаСписка);
		
		СтруктураОбмена = Новый Структура;
		
		Если Не ЗначениеЗаполнено(СтрокаДанных.АдресХранилища) Тогда
			МассивИдентификаторовДокументов = Новый Массив;
			МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
			МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов,
				Не РежимИсходящихДокументов, УникальныйИдентификатор);
			Если МассивДанныхДокументов = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаДанных.АдресХранилища = МассивДанныхДокументов[0];
		КонецЕсли;

		СтруктураОбмена.Вставить("НаименованиеФайла", СтрокаДанных.Документ);
		СтруктураОбмена.Вставить("АдресХранилища",    СтрокаДанных.АдресХранилища);
		
		СписокФайловВХранилище.Добавить(СтруктураОбмена);
	КонецЦикла;
	
	Оповещение = Новый ОписаниеОповещения("СохранитьДокументыЗавершение", ЭтотОбъект, СписокФайловВХранилище);
	ТекстПредложения = НСтр("ru = 'Для сохранения документов необходимо установить расширение для работы с файлами.'");
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(Оповещение, ТекстПредложения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных, АвтоматическаяЗагрузка = Неопределено)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(СтрокаДанных.АдресХранилища) Тогда
		МассивИдентификаторовДокументов = Новый Массив;
		МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
		МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов,
			Не РежимИсходящихДокументов, УникальныйИдентификатор);
		Если МассивДанныхДокументов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		СтрокаДанных.АдресХранилища = МассивДанныхДокументов[0];
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ПолноеИмяФайла");
	ПараметрыОткрытия.Вставить("НаименованиеФайла");
	ПараметрыОткрытия.Вставить("НаправлениеЭД");
	ПараметрыОткрытия.Вставить("Контрагент");
	ПараметрыОткрытия.Вставить("ВладелецЭД");
	ПараметрыОткрытия.Вставить("АдресХранилища");
	ПараметрыОткрытия.Вставить("ФайлАрхива");
	ПараметрыОткрытия.Вставить("Информация");
	ПараметрыОткрытия.Вставить("Статус");
	ПараметрыОткрытия.Вставить("КонтрагентНаименование");
	ПараметрыОткрытия.Вставить("Получатель");
	ПараметрыОткрытия.Вставить("КонтрагентИНН");
	ПараметрыОткрытия.Вставить("КонтрагентКПП");
	ПараметрыОткрытия.Вставить("Дата");
	ПараметрыОткрытия.Вставить("Идентификатор");
	ПараметрыОткрытия.Вставить("КонтактноеЛицо");
	ПараметрыОткрытия.Вставить("Телефон");
	ПараметрыОткрытия.Вставить("ЭлектроннаяПочта");
	ПараметрыОткрытия.Вставить("ИдентификаторВнутренний");
	ПараметрыОткрытия.Вставить("Представление");
	ПараметрыОткрытия.Вставить("СсылкаНаДокумент");
	ПараметрыОткрытия.Вставить("РежимЗаполненияДокумента");
	ПараметрыОткрытия.Вставить("УникальныйИдентификатор");
	ПараметрыОткрытия.Вставить("Источник");
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, СтрокаДанных);
	
	// Заполнение дополнительных параметров.
	ПараметрыОткрытия.СсылкаНаДокумент         = СтрокаДанных.ВладелецЭД;
	ПараметрыОткрытия.РежимЗаполненияДокумента = ЗначениеЗаполнено(СтрокаДанных.ВладелецЭД);
	ПараметрыОткрытия.УникальныйИдентификатор  = УникальныйИдентификатор;
	ПараметрыОткрытия.Источник                 = СтрокаДанных.Источник;
	ПараметрыОткрытия.Представление            = СтрокаДанных.Документ;
	
	Если ЗначениеЗаполнено(АвтоматическаяЗагрузка) Тогда
		ПараметрыОткрытия.Вставить("АвтоматическаяЗагрузка", Истина);
		ПараметрыОткрытия.Вставить("СопоставлятьНоменклатуру", Истина);
	КонецЕсли;
	
	КонтекстВызова = Новый Структура("СтруктураЭД", ПараметрыОткрытия);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента", КонтекстВызова,, ПараметрыОткрытия.ИдентификаторВнутренний);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокДокументов()
	
	Идентификатор = Неопределено;
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		Идентификатор = Элементы.Список.ТекущиеДанные.Идентификатор;
	КонецЕсли;
	
	Отказ = Ложь;
	ОчиститьСообщения();
	ОбновитьСписок(Отказ);
	
	Если Идентификатор <> Неопределено Тогда
		Массив = Список.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
		Если Массив.Количество() Тогда
			ИдентификаторСтроки = Массив[0].ПолучитьИдентификатор();
			Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок(Отказ)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	Если ЗначениеЗаполнено(ОтборКонтрагент) И ВключитьОтборКонтрагент Тогда
		ПараметрыЗапроса.Вставить("Контрагент", ОтборКонтрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборВидДокумента) И ВключитьОтборВидДокумента Тогда
		ПараметрыЗапроса.Вставить("ВидДокумента", ОтборВидДокумента);
	КонецЕсли;
	
	Если НЕ ПоказыватьЗагруженные Тогда
		ПараметрыЗапроса.Вставить("ТолькоНовые", Истина);
	КонецЕсли;
	
	Если РежимИсходящихДокументов Тогда
		ПараметрыЗапроса.Вставить("РежимИсходящихДокументов", Истина);
	КонецЕсли;
	
	// Получение данных из сервиса.
	ПараметрыКоманды = БизнесСеть.ПараметрыКомандыСписокВходящихДокументов(ПараметрыЗапроса, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);

	Список.Очистить();
	
	Если Отказ ИЛИ Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЗначениеМассива Из Результат Цикл
		
		Если ТипЗнч(ЗначениеМассива) <> Тип("Структура") ИЛИ Не ЗначениеМассива.Свойство("documentTitle") Тогда
			ВидОперации = НСтр("ru = 'Чтение списка документов'");
			ПодробныйТекстОшибки = НСтр("ru = 'Внутренняя ошибка чтения данных 1С:Бизнес-сеть. Ошибка формата.'");
			ТекстОшибки = НСтр("ru = 'Внутренняя ошибка чтения данных 1С:Бизнес-сеть.'");
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстОшибки, "БизнесСеть");
			Возврат;
		КонецЕсли;
		
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Документ = ЗначениеМассива.documentTitle;
		Если РежимИсходящихДокументов Тогда
			НоваяСтрока.КонтрагентНаименование = ЗначениеМассива.destinationOrganization.title;
			НоваяСтрока.КонтрагентИНН  = ЗначениеМассива.destinationOrganization.Inn;
			НоваяСтрока.КонтрагентКПП  = БизнесСеть.ЗначениеИдентификатора(
				ЗначениеМассива.destinationOrganization.Kpp);
			НоваяСтрока.ОрганизацияИНН = ЗначениеМассива.sourceOrganization.Inn;
			НоваяСтрока.ОрганизацияКПП = БизнесСеть.ЗначениеИдентификатора(
				ЗначениеМассива.sourceOrganization.Kpp);
		Иначе
			НоваяСтрока.КонтрагентНаименование = ЗначениеМассива.sourceOrganization.title;
			НоваяСтрока.КонтрагентИНН  = ЗначениеМассива.sourceOrganization.Inn;
			НоваяСтрока.КонтрагентКПП  = БизнесСеть.ЗначениеИдентификатора(
				ЗначениеМассива.sourceOrganization.Kpp);
			НоваяСтрока.ОрганизацияИНН = ЗначениеМассива.destinationOrganization.Inn;
			НоваяСтрока.ОрганизацияКПП = БизнесСеть.ЗначениеИдентификатора(
				ЗначениеМассива.destinationOrganization.Kpp);
		КонецЕсли;
		
		НоваяСтрока.ФайлАрхива    = Истина;
		НоваяСтрока.Сумма         = ЗначениеМассива.moneyAmount / 100; // Сервис хранит данные в копейках.
		НоваяСтрока.Информация    = ЗначениеМассива.info;
		НоваяСтрока.Идентификатор = ЗначениеМассива.id;
		НоваяСтрока.НаправлениеЭД = ?(РежимИсходящихДокументов, ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"),
			ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
		НоваяСтрока.ТипОбъекта    = ?(НоваяСтрока.ВозможныеТипыОбъекта.Количество()>0,
			НоваяСтрока.ВозможныеТипыОбъекта[0].Представление, "");
		Если ЗначениеЗаполнено(ЗначениеМассива.sentDate) Тогда
			НоваяСтрока.ДатаДокумента = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЗначениеМассива.sentDate);	
		КонецЕсли;
		НоваяСтрока.Загружен = ?(ЗначениеМассива.deliveryStatus= "SENT", Истина, Ложь);
		НоваяСтрока.ИдентификаторВнутренний = ЗначениеМассива.documentGuid;
		Если Не ЗначениеЗаполнено(НоваяСтрока.ИдентификаторВнутренний) Тогда
			НоваяСтрока.ИдентификаторВнутренний = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		НоваяСтрока.Источник  = ЗначениеМассива;
		
		Если РежимИсходящихДокументов Тогда
			Если ЗначениеМассива.deliveryStatus = "SENT" Тогда 
				НоваяСтрока.Статус = "Отправлен";
			ИначеЕсли ЗначениеМассива.deliveryStatus = "DELIVERED" Тогда
				НоваяСтрока.Статус = "Доставлен";
			ИначеЕсли ЗначениеМассива.deliveryStatus = "REJECTED" Тогда 
				НоваяСтрока.Статус = "Отклонен";
			КонецЕсли;
		Иначе
			Если ЗначениеМассива.deliveryStatus = "SENT" Тогда
				НоваяСтрока.Статус = "Новый";
			ИначеЕсли ЗначениеМассива.deliveryStatus = "DELIVERED" Тогда
				НоваяСтрока.Статус = "Загружен";
			ИначеЕсли ЗначениеМассива.deliveryStatus = "REJECTED" Тогда
				НоваяСтрока.Статус = "Отклонен";
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеМассива.documentPresentationDataType = "pdf" Тогда
			НоваяСтрока.ПредставлениеДокумента = Истина;
		КонецЕсли;
		
		// Контактная информация.
		НоваяСтрока.КонтактноеЛицо   = ЗначениеМассива.person.name;
		НоваяСтрока.Телефон          = ЗначениеМассива.person.phone;
		НоваяСтрока.ЭлектроннаяПочта = ЗначениеМассива.person.email;
		
	КонецЦикла;
	
	Список.Сортировать("ДатаДокумента");
	ЗаполнитьСсылкиТаблицы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСсылкиТаблицы()
	
	ОснованияЭлектронныхДокументов = Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументов.Тип.Типы();
	
	СоответствиеКонтрагентов = Новый Соответствие;
	СоответствиеОрганизаций  = Новый Соответствие;
	
	Для каждого СтрокаТаблицы Из Список Цикл
		
		КлючКонтрагента = СтрокаТаблицы.КонтрагентИНН + СтрокаТаблицы.КонтрагентКПП;
		Контрагент = СоответствиеКонтрагентов.Получить(КлючКонтрагента);
		Если Контрагент = Неопределено Тогда
			ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Контрагенты", СтрокаТаблицы.КонтрагентИНН, 
				СтрокаТаблицы.КонтрагентКПП, Контрагент);
			СоответствиеКонтрагентов.Вставить(КлючКонтрагента, Контрагент);
		КонецЕсли;
		СтрокаТаблицы.Контрагент = Контрагент;
		
		КлючОрганизации = СтрокаТаблицы.ОрганизацияИНН + СтрокаТаблицы.ОрганизацияКПП;
		Организация = СоответствиеОрганизаций.Получить(КлючОрганизации);
		Если Организация = Неопределено Тогда
			ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Организации",
				СтрокаТаблицы.ОрганизацияИНН, СтрокаТаблицы.ОрганизацияКПП, Организация);
			СоответствиеОрганизаций.Вставить(КлючОрганизации, Организация);
		КонецЕсли;
		СтрокаТаблицы.Организация = Организация;
		
		ВидЭДСервиса = СтрокаТаблицы.Источник.DocumentDataType;
		
		Если ПустаяСтрока(СтрокаТаблицы.КонтрагентНаименование) И ЗначениеЗаполнено(СтрокаТаблицы.Контрагент) Тогда
			СтрокаТаблицы.КонтрагентНаименование = Строка(СтрокаТаблицы.Контрагент);
		КонецЕсли;
		
		Если НРег(Лев(ВидЭДСервиса, 3)) = "v8." Тогда
			ВидЭДСервиса = Сред(ВидЭДСервиса, 4);
		КонецЕсли;
		
		Если Метаданные.Перечисления.ВидыЭД.ЗначенияПеречисления.Найти(ВидЭДСервиса) <> Неопределено Тогда
			
			Если Не РежимИсходящихДокументов Тогда
				
				// Поиск документа основания по предопределенному типу.
				ВидДокументаСтроки = Перечисления.ВидыЭД[ВидЭДСервиса];
				СписокТипов = ОбменСКонтрагентамиСлужебный.СписокТиповДокументовПоВидуЭД(ВидДокументаСтроки);
				СтрокаТаблицы.ВидДокумента = ВидДокументаСтроки;
				СтрокаТаблицы.ВозможныеТипыОбъекта = СписокТипов;
				Если ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторВнутренний) И СписокТипов.Количество()>0 Тогда
					Для Счетчик = 0 По СписокТипов.Количество()-1 Цикл
						НаименованиеТипа = СписокТипов.Получить(Счетчик).Значение.Метаданные().Имя;
						ВладелецЭД = Документы[НаименованиеТипа].ПолучитьСсылку(
							Новый УникальныйИдентификатор(СтрокаТаблицы.ИдентификаторВнутренний));
						Если ОбщегоНазначения.СсылкаСуществует(ВладелецЭД) Тогда
							СтрокаТаблицы.ВладелецЭД = ВладелецЭД;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
			Иначе
				
				// Поиск документа основания ЭД по всем доступным типам.
				Для каждого ТипОснования Из ОснованияЭлектронныхДокументов Цикл
					Ссылка = Новый(ТипОснования);
					СсылкаМетаданные = Ссылка.Метаданные();
					Если Метаданные.Документы.Содержит(СсылкаМетаданные) Тогда
						ВладелецЭД = Документы[СсылкаМетаданные.Имя].ПолучитьСсылку(
							Новый УникальныйИдентификатор(СтрокаТаблицы.ИдентификаторВнутренний));
						Если ОбщегоНазначения.СсылкаСуществует(ВладелецЭД) Тогда
							СтрокаТаблицы.ВладелецЭД = ВладелецЭД;
							Прервать;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокументВСервисеПослеВопроса(Результат, МассивСтрок) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = МассивСтрок.Количество();
	ДокументыПоОрганизациям = Новый Соответствие;
	
	Для каждого ЭлементМассива Из МассивСтрок Цикл
		СтрокаДокумента = Список.НайтиПоИдентификатору(ЭлементМассива);
		Если ДокументыПоОрганизациям[СтрокаДокумента.Организация] = Неопределено Тогда
			ДокументыПоОрганизациям.Вставить(СтрокаДокумента.Организация, Новый Структура("МассивИдентификаторов, МассивСтрок", 
				Новый Массив, Новый Массив));
		КонецЕсли;
		ДокументыПоОрганизациям[СтрокаДокумента.Организация].МассивИдентификаторов.Добавить(СтрокаДокумента.Идентификатор);
		ДокументыПоОрганизациям[СтрокаДокумента.Организация].МассивСтрок.Добавить(СтрокаДокумента);
	КонецЦикла;
	
	// Вызов метода удаления по идентификаторам документов.
	Для каждого ВыборкаПоОрганизации Из ДокументыПоОрганизациям Цикл
		МассивИдентификаторов = ВыборкаПоОрганизации.Значение.МассивИдентификаторов;
		Отказ = Ложь;
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Организация", ВыборкаПоОрганизации.Ключ);
		ДополнительныеПараметры.Вставить("ИдентификаторыДокументов", МассивИдентификаторов);
		ДополнительныеПараметры.Вставить("РежимИсходящихДокументов", РежимИсходящихДокументов);
		Результат = БизнесСетьВызовСервера.УдалитьДокументы(ДополнительныеПараметры, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		// Удаление строки в форме списка.
		Для каждого СтрокаДокумента Из ВыборкаПоОрганизации.Значение.МассивСтрок Цикл
			Список.Удалить(СтрокаДокумента);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоСтрок = 1 Тогда
		ТекстОповещения	= НСтр("ru = 'Документ удален.'");
		ТекстПояснения	= НСтр("ru = 'Удален документ в сервисе 1С:Бизнес-сеть.'");
	Иначе
		ТекстОповещения	= НСтр("ru = 'Документы удалены (%1).'");
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, КоличествоСтрок);
		ТекстПояснения	= НСтр("ru = 'Удалены документы в сервисе 1С:Бизнес-сеть.'");
	КонецЕсли;
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено И ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайлов = Новый Массив;
	Для каждого СтруктураОбмена Из ДополнительныеПараметры Цикл
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			СтруктураОбмена.НаименованиеФайла + ".zip", СтруктураОбмена.АдресХранилища);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	Если МассивФайлов.Количество() Тогда
		ПустойОбработчик = Новый ОписаниеОповещения;
		НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ДатаДокумента", "ДатаДокумента");
	
	// Серый цвет для новых контрагентов.
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКонтрагентНаименование.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Контрагент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);

	// Выделение жирным незагруженных документов
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборГруппы = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппы.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ОтборГруппы.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВладелецЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено; // Не заполнен документ учета.
	
	ОтборЭлемента = ОтборГруппы.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = "Отклонен"; // Кроме статуса Отклонен.
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню,,, Истина, Ложь, Ложь, Ложь));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредставление(Команда) 
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		// Получение представления из сервиса.
		МассивИдентификаторовДокументов = Новый Массив;
		МассивИдентификаторовДокументов.Добавить(ТекущиеДанные.Идентификатор);
		МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов,
			Не РежимИсходящихДокументов, УникальныйИдентификатор, Истина);
			
		Если Не ЗначениеЗаполнено(МассивДанныхДокументов) Тогда
			Возврат;
		КонецЕсли;
		
		// Открытие файла.
		ДанныеФайла = Новый Структура;
		ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",  МассивДанныхДокументов[0]);
		ДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ОбщегоНазначенияКлиент.ДатаСеанса());
		ДанныеФайла.Вставить("ОтносительныйПуть", "");
		ДанныеФайла.Вставить("ИмяФайла",          ТекущиеДанные.Документ + ".pdf");
		ДанныеФайла.Вставить("Наименование",      ТекущиеДанные.Документ);
		ДанныеФайла.Вставить("Расширение",        "pdf");
		ДанныеФайла.Вставить("ДляРедактирования", Ложь);
		ДанныеФайла.Вставить("Редактирует",       Неопределено);
		ДанныеФайла.Вставить("Версия",            ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		ДанныеФайла.Вставить("ТекущаяВерсия",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		ДанныеФайла.Вставить("ХранитьВерсии",     Ложь);
		ДанныеФайла.Вставить("РабочийКаталогВладельца",        "");
		ДанныеФайла.Вставить("ПолноеИмяФайлаВРабочемКаталоге", "");
		ДанныеФайла.Вставить("ВРабочемКаталогеНаЧтение",       Ложь);
		ДанныеФайла.Вставить("ПолноеНаименованиеВерсии",       "");
		ДанныеФайла.Вставить("НаЧтение",   Истина);
		ДанныеФайла.Вставить("Зашифрован", Ложь);
		ДанныеФайла.Вставить("Размер",     РазмерФайла(МассивДанныхДокументов[0]));
		ДанныеФайла.Вставить("Ссылка",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазмерФайла(АдресХранилища)
	
	ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	ДвоичныеДанные.Записать(ИмяФайла);
	ФайлНаДиске = Новый Файл(ИмяФайла);
	РазмерФайла = ФайлНаДиске.Размер();
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайла);
	Возврат РазмерФайла;
	
КонецФункции

&НаКлиенте
Процедура ОтклонитьДокументы(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать документ.'"));
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("ОтклонитьДокументыПродолжение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Выделенные документы будут отклонены для загрузки.
							  |Продолжить выполнение операции?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьДокументыПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = МассивСтрок.Количество();
	
	ПараметрыВызова = Новый Массив;
	СтруктураУдаления = Новый Структура;
	Для каждого ЭлементМассива Из МассивСтрок Цикл
		
		СтрокаДокумента = Список.НайтиПоИдентификатору(ЭлементМассива);
		СтруктураУдаления = Новый Структура;
		СтруктураУдаления.Вставить("Ссылка", СтрокаДокумента.ВладелецЭД);
		СтруктураУдаления.Вставить("Идентификатор", СтрокаДокумента.Идентификатор);
		ПараметрыВызова.Добавить(СтруктураУдаления);
		
	КонецЦикла;
	
	Отказ = Ложь;
	БизнесСетьВызовСервера.ОтклонитьДокументы(ПараметрыВызова, Отказ);
	
	Если Не Отказ Тогда
		ОбновитьСписокДокументов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
