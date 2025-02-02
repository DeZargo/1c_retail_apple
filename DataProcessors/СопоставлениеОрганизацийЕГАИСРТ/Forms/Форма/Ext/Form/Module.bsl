﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.АдресВХранилище) Тогда
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		Если СтруктураДанных.Свойство("ОрганизацииЕГАИС") Тогда
			Если ЗначениеЗаполнено(СтруктураДанных.ОрганизацииЕГАИС) Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокОрганизацийЕГАИС, "Ссылка", СтруктураДанных.ОрганизацииЕГАИС, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
				Если ТипЗнч(СтруктураДанных.ОрганизацииЕГАИС) = Тип("СправочникСсылка.КлассификаторОрганизацийЕГАИС") Тогда
					РежимСопоставленияИВыбора = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("Контрагенты") Тогда
			Если ЗначениеЗаполнено(СтруктураДанных.Контрагенты) Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокКонтрагентов, "Ссылка", СтруктураДанных.Контрагенты, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
			КонецЕсли;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("Организации") Тогда
			Если ЗначениеЗаполнено(СтруктураДанных.Организации) Тогда
				ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокОрганизаций, "Ссылка", СтруктураДанных.Организации, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("РежимСопоставленияОрганизаций") Тогда
		РежимСопоставленияОрганизаций = Истина;
		ИзменитьФормуДляСопоставленияОрганизаций();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОтборПоИНН ИЛИ ОтборПоКПП Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьОтборКонтрагентов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ВосстановитьНастройкиНаСервере(Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоИННПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьОтборКонтрагентов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоКПППриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьОтборКонтрагентов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораСоответствийОрганизацииЕГАИСПриИзменении(Элемент)
	
	УстановитьОтборПоСоответствиюОрганизацииЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтбораСоответствийКонтрагентыПриИзменении(Элемент)
	
	УстановитьОтборПоСоответствиюКонтрагенты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура СписокОрганизацийЕГАИСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если РежимСопоставленияОрганизаций Тогда
		ТекущийСписок = Элементы.СписокОрганизаций;
	Иначе
		ТекущийСписок = Элементы.СписокКонтрагентов;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные <> Неопределено И НЕ Элемент.ТекущиеДанные.Контрагент.Пустая() Тогда
		ТекущийСписок.ТекущаяСтрока = Элемент.ТекущиеДанные.Контрагент;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено И Элемент.ТекущиеДанные.ЕстьСоответствие Тогда
		СвязанныеОрганизацииЕГАИС = ПолучитьСписокСвязанныхОрганизацийЕГАИС(Элемент.ТекущиеДанные.Ссылка);
		
		Если СвязанныеОрганизацииЕГАИС.Количество() > 0 Тогда
			Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки.Очистить();
			Элементы.СписокОрганизацийЕГАИС.ТекущаяСтрока = СвязанныеОрганизацииЕГАИС[0];
			
			Для каждого ОрганизацияЕГАИС Из СвязанныеОрганизацииЕГАИС Цикл
				Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки.Добавить(ОрганизацияЕГАИС);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОрганизацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено И Элемент.ТекущиеДанные.ЕстьСоответствие Тогда
		СвязанныеОрганизацииЕГАИС = ПолучитьСписокСвязанныхОрганизацийЕГАИС(Элемент.ТекущиеДанные.Ссылка);
		
		Если СвязанныеОрганизацииЕГАИС.Количество() > 0 Тогда
			Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки.Очистить();
			Элементы.СписокОрганизацийЕГАИС.ТекущаяСтрока = СвязанныеОрганизацииЕГАИС[0];
			
			Для каждого ОрганизацияЕГАИС Из СвязанныеОрганизацииЕГАИС Цикл
				Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки.Добавить(ОрганизацияЕГАИС);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОрганизацийЕГАИСПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоИНН ИЛИ ОтборПоКПП Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьОтборКонтрагентов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСоответствие(Команда)
	
	Если РежимСопоставленияОрганизаций Тогда
		ТекущийСписок = Элементы.СписокОрганизаций;
	Иначе
		ТекущийСписок = Элементы.СписокКонтрагентов;
	КонецЕсли;
	
	Если Элементы.СписокОрганизацийЕГАИС.ТекущиеДанные = Неопределено 
		ИЛИ ТекущийСписок.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	Если НЕ ПроверитьВозможностьУстановкиСоответствия(Элементы.СписокОрганизацийЕГАИС.ТекущиеДанные.Ссылка, ТекущийСписок.ТекущиеДанные.Ссылка, ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОрганизацияЕГАИС", Элементы.СписокОрганизацийЕГАИС.ТекущиеДанные.Ссылка);
	ПараметрыФормы.Вставить("Контрагент", ТекущийСписок.ТекущиеДанные.Ссылка);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("УстановитьСоответствие_Завершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.СопоставлениеОрганизацийЕГАИСРТ.Форма.ФормаСопоставленияКонтрагентов", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСоответствие_Завершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Истина Тогда
		Если РежимСопоставленияИВыбора Тогда
			Закрыть(РезультатЗакрытия);
			Возврат;
		КонецЕсли;
		Элементы.СписокОрганизацийЕГАИС.Обновить();
		Если РежимСопоставленияОрганизаций Тогда
			Элементы.СписокОрганизаций.Обновить();
		Иначе
			Элементы.СписокКонтрагентов.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСоответствие(Команда)
	
	МассивЭлементов = Новый Массив;
	
	Для каждого ОрганизацияЕГАИС Из Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки Цикл
	
		ДанныеСтроки = Элементы.СписокОрганизацийЕГАИС.ДанныеСтроки(ОрганизацияЕГАИС);
		Если НЕ ДанныеСтроки.Контрагент.Пустая() Тогда
			МассивЭлементов.Добавить(ОрганизацияЕГАИС);
		КонецЕсли;
	
	КонецЦикла;
	
	Если МассивЭлементов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	АдресМассиваОрганизацийЕГАИС = ПоместитьВоВременноеХранилище(МассивЭлементов, УникальныйИдентификатор);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОтменитьСоответствие_Завершение", ЭтотОбъект);
	ПоказатьВопрос(ОповещениеПриЗавершении, НСтр("ru = 'Отменить связь выбранных организаций?'"), РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСоответствие_Завершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтменитьСоответствие", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагентов(Команда)
	
	МассивЭлементов = Элементы.СписокОрганизацийЕГАИС.ВыделенныеСтроки;
	Если МассивЭлементов.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ТекстОшибки = "";
	Если НЕ ПроверитьВозможностьСозданияКонтрагентов(МассивЭлементов, ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("СоздатьКонтрагентов_Подтверждение", ЭтотОбъект, МассивЭлементов);
	ПоказатьВопрос(ОповещениеПриЗавершении, НСтр("ru = 'Создать контрагентов по выделенным строкам организаций ЕГАИС?'"), РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагентов_Подтверждение(РезультатВопроса, ВыделенныеСтроки) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	АдресСпискаОрганизацийЕГАИС = ПоместитьВоВременноеХранилище(ВыделенныеСтроки, УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресСпискаОрганизацийЕГАИС", АдресСпискаОрганизацийЕГАИС);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("СоздатьКонтрагентов_Завершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.СопоставлениеОрганизацийЕГАИСРТ.Форма.ФормаСозданияКонтрагентов", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагентов_Завершение(ПараметрыСозданияКонтрагентов, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ПараметрыСозданияКонтрагентов) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	АдресПараметровСозданияКонтрагентов = ПоместитьВоВременноеХранилище(ПараметрыСозданияКонтрагентов, УникальныйИдентификатор);
	
	ПодключитьОбработчикОжидания("Подключаемый_СоздатьКонтрагентов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОрганизациюПоИНН(Команда)
	
	Если РежимСопоставленияОрганизаций Тогда
		ТекущийСписок = Элементы.СписокОрганизаций;
	Иначе
		ТекущийСписок = Элементы.СписокКонтрагентов;
	КонецЕсли;
	
	ТекущиеДанные = ТекущийСписок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция"         , ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросДанныхОрганизации"));
	ПараметрыФормы.Вставить("ИмяПараметра"     , "ИНН");
	ПараметрыФормы.Вставить("ЗначениеПараметра", ТекущиеДанные.ИНН);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАлкогольнуюПродукциюПоИННКонтрагента(Команда)
	
	ТекущиеДанные = Элементы.СписокКонтрагентов.ТекущиеДанные;
	ЗагрузитьАлкогольнуюПродукциюПоИНН(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАлкогольнуюПродукциюПоИННКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.СписокОрганизацийЕГАИС.ТекущиеДанные;
	ЗагрузитьАлкогольнуюПродукциюПоИНН(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_СоздатьКонтрагентов()
	
	СозданныеКонтрагенты = СоздатьКонтрагентовНаСервере(АдресПараметровСозданияКонтрагентов);
	
	Если РежимСопоставленияИВыбора Тогда
		Закрыть(Истина);
		Возврат;
	КонецЕсли;
	
	Элементы.СписокОрганизацийЕГАИС.Обновить();
	Элементы.СписокКонтрагентов.Обновить();
	
	Элементы.СписокКонтрагентов.ВыделенныеСтроки.Очистить();
	
	Для каждого Контрагент Из СозданныеКонтрагенты Цикл
		Элементы.СписокКонтрагентов.ВыделенныеСтроки.Добавить(Контрагент);
	КонецЦикла;
	
	Если СозданныеКонтрагенты.Количество() = 1 Тогда
		ТекстСообщения = НСтр("ru = 'Создан контрагент %Наименование%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Наименование%", СокрЛП(СозданныеКонтрагенты[0]));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СозданныеКонтрагенты[0]);
	Иначе
		ТекстСообщения = НСтр("ru = 'Создано %Количество% контрагентов.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", СозданныеКонтрагенты.Количество());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменитьСоответствие()
	
	ОтменитьСоответствиеНаСервере(ПолучитьИзВременногоХранилища(АдресМассиваОрганизацийЕГАИС));
	
	Элементы.СписокОрганизацийЕГАИС.Обновить();
	Если РежимСопоставленияОрганизаций Тогда
		Элементы.СписокОрганизаций.Обновить();
	Иначе
		Элементы.СписокКонтрагентов.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьКонтрагентовНаСервере(АдресПараметровСозданияКонтрагентов)
	
	СозданныеКонтрагенты = Новый Массив;
	
	ПараметрыСозданияКонтрагентов = ПолучитьИзВременногоХранилища(АдресПараметровСозданияКонтрагентов);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого ОрганизацияЕГАИС Из ПараметрыСозданияКонтрагентов.МассивЭлементов Цикл
		
		РеквизитыОрганизацииЕГАИС = ПолучитьРеквизитыОрганизацииЕГАИС(ОрганизацияЕГАИС);
		
		КонтрагентОбъект  = Справочники.Контрагенты.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(КонтрагентОбъект, РеквизитыОрганизацииЕГАИС);
		
		КонтрагентОбъект.Родитель = ПараметрыСозданияКонтрагентов.Родитель;
		КонтрагентОбъект.ЮрФизЛицо = ПараметрыСозданияКонтрагентов.ЮрФизЛицо;
		
		Если НЕ ПустаяСтрока(РеквизитыОрганизацииЕГАИС.ПредставлениеАдреса) Тогда
			СтрокаКИ = КонтрагентОбъект.КонтактнаяИнформация.Добавить();
			СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
			СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента;
			СтрокаКИ.Представление = СокрЛП(РеквизитыОрганизацииЕГАИС.ПредставлениеАдреса);
			СтрокаКИ.ЗначенияПолей = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(СтрокаКИ.Представление, СтрокаКИ.Вид);
			СтрокаКИ.Значение = СтрокаКИ.ЗначенияПолей;
		КонецЕсли;
		
		КонтрагентОбъект.Записать();
		
		ОрганизацияЕГАИСОбъект = ОрганизацияЕГАИС.ПолучитьОбъект();
		ОрганизацияЕГАИСОбъект.СоответствуетОрганизации = Ложь;
		ОрганизацияЕГАИСОбъект.Контрагент = КонтрагентОбъект.Ссылка;
		ОрганизацияЕГАИСОбъект.Записать();
		
		СозданныеКонтрагенты.Добавить(КонтрагентОбъект.Ссылка);
		
	КонецЦикла;
	
	Возврат СозданныеКонтрагенты;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыОрганизацииЕГАИС(ОрганизацияЕГАИС)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ОрганизацияЕГАИС);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Наименование,
	|	КлассификаторОрганизацийЕГАИС.НаименованиеПолное,
	|	КлассификаторОрганизацийЕГАИС.ИНН,
	|	КлассификаторОрганизацийЕГАИС.КПП,
	|	КлассификаторОрганизацийЕГАИС.ПредставлениеАдреса
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить().Выгрузить()[0];
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьСоответствиеНаСервере(МассивОрганизацийЕГАИС)
	
	Для каждого ОрганизацияЕГАИС Из МассивОрганизацийЕГАИС Цикл
		
		ЕстьСоответствие = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияЕГАИС, "Сопоставлено");
		Если НЕ ЕстьСоответствие Тогда
			Продолжить;
		КонецЕсли;
		
		Спр = ОрганизацияЕГАИС.ПолучитьОбъект();
		Спр.Контрагент = Неопределено;
		Спр.ТорговыйОбъект = Неопределено;
		Спр.Записать();
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВозможностьУстановкиСоответствия(ОрганизацияЕГАИС, Контрагент, ТекстОшибки)
	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
		Если Контрагент.ЭтоГруппа Тогда
			ТекстОшибки = НСтр("ru = 'Связка организации ЕГАИС с группой контрагентов невозможна.'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Ссылка = &ОрганизацияЕГАИС
	|	И КлассификаторОрганизацийЕГАИС.Сопоставлено
	|	И КлассификаторОрганизацийЕГАИС.Контрагент <> &Контрагент";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстОшибки = НСтр("ru = 'Выбранная организация уже имеет связку.'");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьВозможностьСозданияКонтрагентов(МассивОрганизацийЕГАИС, ТекстОшибки)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОрганизацийЕГАИС", МассивОрганизацийЕГАИС);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Ссылка В(&МассивОрганизацийЕГАИС)
	|	И НЕ КлассификаторОрганизацийЕГАИС.Сопоставлено";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Если МассивОрганизацийЕГАИС.Количество() > 1 Тогда
			ТекстОшибки = НСтр("ru = 'Все выбранные организации уже имеют связку.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Выбранная организация уже имеет связку.'");
		КонецЕсли;
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокСвязанныхОрганизацийЕГАИС(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Контрагент = &Контрагент
	|	И КлассификаторОрганизацийЕГАИС.Сопоставлено";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьОтборКонтрагентов()
	
	УстановитьОтборКонтрагентовПоСвойствамОрганизацииЕГАИС();
	
	ЭтотОбъект.ТекущийЭлемент = Элементы.СписокОрганизацийЕГАИС;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборКонтрагентовПоСвойствамОрганизацииЕГАИС()
	
	ТекущиеДанные = Элементы.СписокОрганизацийЕГАИС.ТекущиеДанные;
	
	ИспользованиеОтборов = ТекущиеДанные <> Неопределено;
	
	ГруппаОтбора = ОтборыСписковКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокКонтрагентов.Отбор.Элементы,
		"ОтборПоСвойствамОрганизацииЕГАИС",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
		ГруппаОтбора,
		"ИНН",
		?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.ИНН),
		ИспользованиеОтборов И ОтборПоИНН И НЕ ПустаяСтрока(ТекущиеДанные.ИНН), ВидСравненияКомпоновкиДанных.Равно);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
		ГруппаОтбора,
		"КПП",
		?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.КПП),
		ИспользованиеОтборов И ОтборПоКПП И НЕ ПустаяСтрока(ТекущиеДанные.КПП), ВидСравненияКомпоновкиДанных.Равно);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоСоответствиюОрганизацииЕГАИС()
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			СписокОрганизацийЕГАИС,
			"Контрагент",
			ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"),
			НЕ ВариантОтбораСоответствийОрганизацииЕГАИС = "Все", 
			?(ВариантОтбораСоответствийОрганизацииЕГАИС = "Связанные", ВидСравненияКомпоновкиДанных.НеРавно, ВидСравненияКомпоновкиДанных.Равно));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСоответствиюОрганизацииЕГАИСНаСервере()
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			СписокОрганизацийЕГАИС,
			"Контрагент",
			ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"),
			НЕ ВариантОтбораСоответствийОрганизацииЕГАИС = "Все", 
			?(ВариантОтбораСоответствийОрганизацииЕГАИС = "Связанные", ВидСравненияКомпоновкиДанных.НеРавно, ВидСравненияКомпоновкиДанных.Равно));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоСоответствиюКонтрагенты()
	
	Если РежимСопоставленияОрганизаций Тогда
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			СписокОрганизаций,
			"ЕстьСоответствие",
			Истина,
			НЕ ВариантОтбораСоответствийКонтрагенты = "Все", 
			?(ВариантОтбораСоответствийКонтрагенты = "Связанные", ВидСравненияКомпоновкиДанных.Равно, ВидСравненияКомпоновкиДанных.НеРавно));
	Иначе
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			СписокКонтрагентов,
			"ЕстьСоответствие",
			Истина,
			НЕ ВариантОтбораСоответствийКонтрагенты = "Все", 
			?(ВариантОтбораСоответствийКонтрагенты = "Связанные", ВидСравненияКомпоновкиДанных.Равно, ВидСравненияКомпоновкиДанных.НеРавно));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСоответствиюКонтрагентыНаСервере()
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
			СписокКонтрагентов,
			"ЕстьСоответствие",
			Истина,
			НЕ ВариантОтбораСоответствийКонтрагенты = "Все", 
			?(ВариантОтбораСоответствийКонтрагенты = "Связанные", ВидСравненияКомпоновкиДанных.Равно, ВидСравненияКомпоновкиДанных.НеРавно));
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиНаСервере(Знач Настройки)
	
	НастройкиПоУмолчанию = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("ВариантОтбораСоответствийКонтрагенты")) Тогда
		Настройки.Вставить("ВариантОтбораСоответствийКонтрагенты", "Все");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("ВариантОтбораСоответствийОрганизацииЕГАИС")) Тогда
		Настройки.Вставить("ВариантОтбораСоответствийОрганизацииЕГАИС", "Все");
	КонецЕсли;
	
	Для Каждого Настройка Из Настройки Цикл
		НастройкиПоУмолчанию.Вставить(Настройка.Ключ, Настройка.Значение);
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиПоУмолчанию);
	
	УстановитьОтборПоСоответствиюОрганизацииЕГАИСНаСервере();
	УстановитьОтборПоСоответствиюКонтрагентыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАлкогольнуюПродукциюПоИНН(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Операция"         , ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАлкогольнойПродукции"));
	ПараметрыФормы.Вставить("ИмяПараметра"     , "ИНН");
	ПараметрыФормы.Вставить("ЗначениеПараметра", ТекущиеДанные.ИНН);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормированиеИсходящегоЗапросаЕГАИС",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьФормуДляСопоставленияОрганизаций()
	
	Элементы.ЗаголовокКонтрагенты.Заголовок = "Организации";
	
	Элементы.ФормаСоздатьКонтрагентов.Видимость = Ложь;
	
	Элементы.СписокКонтрагентов.Видимость = Ложь;
	Элементы.СписокОрганизаций.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти
