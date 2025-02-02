﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ТипШаблона.ТолькоПросмотр = Истина;
		Элементы.ОбъектМетаданных.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Справочники);
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Документы);
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбъектИсточник = Параметры.ЗначениеКопирования.ПолучитьОбъект();
	Иначе
		ОбъектИсточник = РеквизитФормыВЗначение("Объект", Тип("СправочникОбъект.ХранилищеШаблонов"));
	КонецЕсли;
	
	СтруктураШаблона = ОбъектИсточник.Шаблон.Получить();
	СКД = ОбъектИсточник.СхемаКомпоновкиДанных.Получить();
	
	Если ТипЗнч(СтруктураШаблона) = Тип("Структура") Тогда
		СтруктураШаблона.Свойство("XMLОписаниеМакета", XMLОписаниеМакета);
	КонецЕсли;
	
	АдресШаблона = ПоместитьВоВременноеХранилище(СтруктураШаблона, УникальныйИдентификатор);
	
	Если СКД <> Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЗначениеЗаполнено(АдресШаблона) Тогда
		СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
		Если СтруктураШаблона <> Неопределено Тогда
			ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(СтруктураШаблона);
			Если СтруктураШаблона.Свойство("АдресСКДВХранилище") Тогда
				АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(АдресСКД) Тогда
		СКД = ПолучитьИзВременногоХранилища(АдресСКД);
		ТекущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(СКД);
		Если НЕ Отказ Тогда
			Если НЕ ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ТипШаблона.ТолькоПросмотр = Истина;
	Элементы.ОбъектМетаданных.ТолькоПросмотр = Истина;
	Элементы.ОбъектМетаданных.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ОбъектМетаданных.ОтметкаНезаполненного = Ложь;
	УстановитьВидимостьКомандыРедактироватьСКД();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененШаблон"
		ИЛИ ИмяСобытия = "ИзмененШаблонЧека" Тогда
		АдресШаблона = Параметр;
		Модифицированность = Истина;
		Если ИмяСобытия = "ИзмененШаблон"
			И ЗначениеЗаполнено(АдресШаблона) Тогда
			СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
			Если СтруктураШаблона <> Неопределено Тогда
				Если СтруктураШаблона.Свойство("АдресСКДВХранилище")
					И ЗначениеЗаполнено(СтруктураШаблона.АдресСКДВХранилище) Тогда
					АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипШаблонаПриИзменении(Элемент)
	
	Объект.ОбъектМетаданных = "";
	АдресШаблона = "";
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элементы.Наименование.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.ОбъектМетаданных) 
		И Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных) <> Неопределено
	Тогда
		СтрокаНаименования = Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных).Представление;
		Элементы.Наименование.СписокВыбора.Добавить("Чек " + СтрокаНаименования);
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуРедактированияМакета(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПерейтиКРедактированиюМакетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Для редактирования шаблона необходимо записать элемент. Записать?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ПерейтиКРедактированиюМакета();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСКД(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Оповещение = Новый ОписаниеОповещения("РедактироватьСКДЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Для редактирования схемы компоновки данных необходимо записать элемент! Записать?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ПерейтиКРедактированиюСКД();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиКРедактированиюМакетаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ЭтотОбъект.Записать();
			ПерейтиКРедактированиюМакета();
			
		КонецЕсли;;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРедактированиюМакета()
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток") Тогда
		
		Если НЕ ЗначениеЗаполнено(АдресСКД) Тогда
			УстановитьСКДПоУмолчанию();
		КонецЕсли;
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьРедактированиеМакетаЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьРедактированиеМакета(ОповещениеПриЗавершении, XMLОписаниеМакета, АдресСКД);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОткрытия.Вставить("ТипШаблона", Объект.ТипШаблона);
	ПараметрыОткрытия.Вставить("АдресШаблона", АдресШаблона);
	ПараметрыОткрытия.Вставить("АдресСКД", АдресСКД);
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ФискальныйЧек") Тогда
		ПараметрыОткрытия.Вставить("ОбъектМетаданных", Объект.ОбъектМетаданных);
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблонаФискальногоЧека",
						ПараметрыОткрытия,
						ЭтотОбъект,
						,
						,
						,
						,
						РежимОткрытияОкнаФормы.Независимый);
	ИначеЕсли Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЧекККТ") Тогда
		ПараметрыОткрытия.Вставить("ОбъектМетаданных", Объект.ОбъектМетаданных);
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблонаЧекаККТ",
						ПараметрыОткрытия,
						ЭтотОбъект,
						,
						,
						,
						,
						РежимОткрытияОкнаФормы.Независимый);
	Иначе
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблона",
						ПараметрыОткрытия,
						ЭтотОбъект,
						,
						,
						,
						,
						РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли;
					
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокМетаданныхИспользующихШаблоны(КоллекцияМетаданных)
	
	Для Каждого МетаданныеОбъекта Из КоллекцияМетаданных Цикл
		Для Каждого Макет Из МетаданныеОбъекта.Макеты Цикл
			Если ВРег(Макет.Имя) = ВРег("ПоляШаблона") Тогда
				Элементы.ОбъектМетаданных.СписокВыбора.Добавить(МетаданныеОбъекта.ПолноеИмя(), МетаданныеОбъекта.Представление());
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Элементы.ОбъектМетаданных.СписокВыбора.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ЭтоЧекККТ = Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЧекККТ;
	ВидимостьОбъектаМетаданных = ЭтоЧекККТ ИЛИ Объект.ТипШаблона = Перечисления.ТипыШаблонов.ФискальныйЧек;
	Элементы.ОбъектМетаданных.Видимость = ВидимостьОбъектаМетаданных;
	Элементы.РазмерМакета.Видимость = Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток");
	УстановитьВидимостьКомандыРедактироватьСКД();
	
КонецПроцедуры

&НаСервере
Функция ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект)
	
	ВсеВерно = Истина;
	Если ТекущийОбъект.СхемаКомпоновкиДанных <> Неопределено Тогда
		
		ПроверяемаяСхема = ТекущийОбъект.СхемаКомпоновкиДанных.Получить();
		
		Если ПроверяемаяСхема = Неопределено Тогда
			Возврат ВсеВерно;
		КонецЕсли;
		
		// Подготовка компоновщика макета компоновки данных, загрузка настроек.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПроверяемаяСхема));
		
		КомпоновщикНастроек.ЗагрузитьНастройки(ПроверяемаяСхема.НастройкиПоУмолчанию);

		НастройкиСКД = КомпоновщикНастроек.Настройки;
		СписокПараметровСКД = НастройкиСКД.ПараметрыДанных.Элементы;
		ИндексПараметра = 0;
		Для Каждого ПараметрСКД Из СписокПараметровСКД Цикл
			Если ТипЗнч(ПараметрСКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				ПараметрНастроек = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(ПараметрСКД.Параметр);
				Если ПараметрНастроек <> Неопределено И ПараметрНастроек.ЗапрещатьНезаполненныеЗначения Тогда
					Если (НЕ ПараметрСКД.Использование) ИЛИ (НЕ ЗначениеЗаполнено(ПараметрСКД.Значение)) Тогда
						ТекстСообщения = НСтр("ru = 'В схеме компоновки не заполнено значение обязательного параметра ""%1"". Откройте редактор макета и настройте параметры СКД.'");
						ИмяПараметраСКД = ?(ЗначениеЗаполнено(ПараметрСКД.ПредставлениеПользовательскойНастройки),
												ПараметрСКД.ПредставлениеПользовательскойНастройки,
												?(ЗначениеЗаполнено(ПараметрНастроек.Заголовок),
																	ПараметрНастроек.Заголовок,
																	ПараметрНастроек.Имя));
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИмяПараметраСКД);
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							ТекстСообщения,
							,
							"ФормаРедактироватьМакет",
							"Объект");
						ВсеВерно = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ИндексПараметра = ИндексПараметра + 1;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ВсеВерно;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьКомандыРедактироватьСКД()
	
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЧекККТ
		ИЛИ Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенник
		ИЛИ Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток Тогда
		Элементы.ФормаРедактироватьСКД.Видимость = Истина;
	Иначе
		Элементы.ФормаРедактироватьСКД.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаОткрытияНастройкиСКД()
	
	Если ЗначениеЗаполнено(АдресСКД) Тогда
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
		Если ЗначениеЗаполнено(АдресШаблона) Тогда
			СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
			Если СтруктураШаблона <> Неопределено Тогда
				Если СтруктураШаблона.Свойство("АдресСКДВХранилище") Тогда
					СтруктураШаблона.АдресСКДВХранилище = АдресСКД;
					АдресШаблона = ПоместитьВоВременноеХранилище(СтруктураШаблона, УникальныйИдентификатор);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеМакетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Объект.РазмерМакета = ДополнительныеПараметры.РазмерМакета;
		XMLОписаниеМакета = ДополнительныеПараметры.XMLОписаниеМакета;
		Поля.Очистить();
		
		Для Каждого ТекПоле Из ДополнительныеПараметры.Поля Цикл
			
			НовоеПоле = Поля.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеПоле, ТекПоле);
			
		КонецЦикла;
		
		АдресШаблона = СохранитьЗакрытьСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗакрытьСервер()
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураМакетаШаблона(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция СтруктураМакетаШаблона()
	
	СтруктураМакетаШаблона = Новый Структура;
	
	СтруктураМакетаШаблона.Вставить("РазмерМакета"				, Объект.РазмерМакета);
	СтруктураМакетаШаблона.Вставить("XMLОписаниеМакета"			, XMLОписаниеМакета);
	СтруктураМакетаШаблона.Вставить("АдресСКДВХранилище"		, АдресСКД);
	
	ПоляМакета = Новый Массив;
	
	Для Каждого ТекПоле Из Поля Цикл
		
		НовоеПоле = Новый Структура("Наименование, ТипЗаполнения, Значение, ЗначениеПоУмолчанию, Тип",
			ТекПоле.Наименование,
			ТекПоле.ТипЗаполнения,
			ТекПоле.Значение,
			ТекПоле.ЗначениеПоУмолчанию,
			ТекПоле.Тип);
			
		ПоляМакета.Добавить(НовоеПоле);
		
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("ПоляМакета", ПоляМакета);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиКРедактированиюСКД()
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенник")
		ИЛИ Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток")
		ИЛИ Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЧекККТ") Тогда
		
		Если НЕ ЗначениеЗаполнено(АдресСКД) Тогда
			УстановитьСКДПоУмолчанию();
		КонецЕсли;
		ФильтрИсточникаШаблонов = Неопределено;
		Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЧекККТ") Тогда
			ИсточникШаблонов = ПредопределенноеЗначение(Объект.ОбъектМетаданных + ".ПустаяСсылка");
			ФильтрИсточникаШаблонов = Новый Массив;
			ФильтрИсточникаШаблонов.Добавить("ПоляШаблонаЧекККТ");
			Если Объект.ОбъектМетаданных = "Документ.ЧекККМ" Тогда
				ФильтрИсточникаШаблонов.Добавить("ПоляШаблонаЧекККТРасширенный");
			КонецЕсли;
		Иначе
			ИсточникШаблонов = Объект.Ссылка;
		КонецЕсли;
		
		ЗаголовокСКД = НСтр("ru = 'Настройки СКД шаблона ""%1""'");
		ЗаголовокСКД = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокСКД, Объект.Наименование);
		
		ПараметрыОткрытия = Новый Структура("АдресСхемыКомпоновкиДанных,
											 |ИсточникШаблонов,
											 |ФильтрИсточникаШаблонов,
											 |Заголовок,
											 |УникальныйИдентификатор,
											 |ИмяШаблонаСКД,
											 |ВозвращатьИмяТекущегоШаблонаСКД",
											 АдресСКД,
											 ИсточникШаблонов,
											 ФильтрИсточникаШаблонов,
											 ЗаголовокСКД,
											 УникальныйИдентификатор,
											 ИмяШаблонаСКД,
											 Истина);
		ДополнительныеПараметры = Новый Структура;
		ОбработчикОповещения = Новый ОписаниеОповещения("ПерейтиКРедактированиюСКДЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных", ПараметрыОткрытия, ЭтотОбъект, , , , ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСКДЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ЭтотОбъект.Записать();
			ПерейтиКРедактированиюСКД();
			
		КонецЕсли;;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРедактированиюСКДЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтотОбъект.Модифицированность = Истина;
		ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
		ОбработкаОткрытияНастройкиСКД();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСКДПоУмолчанию()
	
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенник
		ИЛИ Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток Тогда
		СКД = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблона");
		АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	ИначеЕсли Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЧекККТ Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(Объект.ОбъектМетаданных);
		ИмяОбъектаМетаданных = МетаданныеОбъекта.Имя;
		
		Если МетаданныеОбъекта = Неопределено Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не указан объект метаданных: %1'"),
					Объект.ОбъектМетаданных);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя());
		Если МенеджерОбъекта <> Неопределено Тогда
			СКД = МенеджерОбъекта.ПолучитьМакет("ПоляШаблонаЧекККТ");
			АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
