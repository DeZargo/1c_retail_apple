﻿
#Область СлужебныйПрограммныйИнтерфейс

// Только для внутреннего использования.
// Вызывается из: ПодготовитьСообщенияКПередаче
Функция ВозможнаОтправкаПодтверждения(СсылкиДокументов) Экспорт
	
	Отказ = Ложь;
	
	СтатусыПроверкиИПодбора = ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъектов(СсылкиДокументов, "СтатусПроверкиИПодбора");
	
	КоличествоПроверенныхДокументов = 0;
	
	Для Каждого КлючЗначение Из СтатусыПроверкиИПодбора Цикл
		Если ЗавершенаПроверкаИПодбор(КлючЗначение.Значение) Тогда
			КоличествоПроверенныхДокументов = КоличествоПроверенныхДокументов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоПроверенныхДокументов <> СсылкиДокументов.Количество() Тогда
		Если КоличествоПроверенныхДокументов = 0 Тогда
			Если СсылкиДокументов.Количество() = 1 Тогда
				СообщениеПользователю = НСтр("ru = 'В указанном документе не выполнена проверка поступившей алкогольной продукции.'");
			Иначе
				СообщениеПользователю = НСтр("ru = 'В указанных документах не выполнена проверка поступившей алкогольной продукции.'");
			КонецЕсли;
		Иначе
			СообщениеПользователю = НСтр("ru = 'Не во всех указанных документах выполнена проверка поступившей алкогольной продукции.'");
		КонецЕсли;
		СообщениеПользователю = СообщениеПользователю + " " + НСтр("ru = 'Отправка подтверждения возможна только после завершения проверки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю,,,, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

// Только для внутреннего использования.
Функция ЗавершенаПроверкаИПодбор(СтатусПроверкиИПодбора) Экспорт
	
	Возврат СтатусПроверкиИПодбора = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиИПодбораИС.Завершено");
	
КонецФункции

// Только для внутреннего использования.
Функция ВыполняетсяПроверкаИПодбор(СтатусПроверкиИПодбора) Экспорт
	
	Возврат СтатусПроверкиИПодбора = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиИПодбораИС.Выполняется");
	
КонецФункции

// Только для внутреннего использования.
Функция НоваяСтруктураСписокВходящихДокументов(ДанныеОбработки, ТекстОшибки)
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеОбработки",             ДанныеОбработки);
	Результат.Вставить("ТекстОшибки",                 ТекстОшибки);
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
// Вызывается из: ИнтеграцияЕГАИСКлиент.ПроверитьВходящиеДокументы.
//
// Параметры:
//  Результат - Структура - Структура со свойствами:
//   * ТекстОшибки
//   * ДанныеОбработки
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПроверитьВходящиеДокументы_ОбработатьСписокВходящихДокументов(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстОшибки = Результат.ТекстОшибки;
	
	Для Каждого СтрокаТЧ Из Результат.ДанныеОбработки Цикл
		ДополнительныеПараметры.АдресаURLВходящихДокументов.Добавить(СтрокаТЧ);
	КонецЦикла;
	
	Результат = НоваяСтруктураСписокВходящихДокументов(
		ДополнительныеПараметры.АдресаURLВходящихДокументов,
		ТекстОшибки);
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#Область ГлобальныеОбработчикиОбмена

// Только для внутреннего использования.
// Вызывается из: ПослеЗавершенияОбмена
Процедура ОткрытьРезультатВыполненияОбменаЕГАИС(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Изменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.РезультатВыполненияОбменаЕГАИС", ДополнительныеПараметры);
	
КонецПроцедуры

// Только для внутреннего использования.
// Вызывается из: ОповещениеПослеЗавершенииОбмена
Процедура ПослеЗавершенияОбмена(Изменения, ДополнительныеПараметры) Экспорт
	
	СоответствиеДокументыОснования  = Новый Соответствие;
	СоответствиеДокументыСтатусы    = Новый Соответствие;
	СоответствиеИзмененныеДокументы = Новый Соответствие;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		
		Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			ИнтеграцияЕГАИСКлиентСервер.СообщитьПользователюВФорму(ДополнительныеПараметры.ИдентификаторВладельца, ЭлементДанных.ТекстОшибки);
		КонецЕсли;
		
		СоответствиеДокументыОснования.Вставить(ЭлементДанных.Объект, ЭлементДанных.ДокументОснование);
		СоответствиеДокументыСтатусы.Вставить(ЭлементДанных.Объект, ЭлементДанных.НовыйСтатус);
		Если ЭлементДанных.ОбъектИзменен Тогда
			СоответствиеИзмененныеДокументы.Вставить(ЭлементДанных.Объект, Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из СоответствиеДокументыОснования Цикл
		
		ОбъектИзменен = СоответствиеИзмененныеДокументы.Получить(КлючИЗначение.Ключ);
		Если ОбъектИзменен = Неопределено Тогда
			ОбъектИзменен = Ложь;
		КонецЕсли;
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Ссылка",        КлючИЗначение.Ключ);
		ПараметрОповещения.Вставить("Основание",     КлючИЗначение.Значение);
		ПараметрОповещения.Вставить("ОбъектИзменен", ОбъектИзменен);
		
		Оповестить("ИзменениеСостоянияЕГАИС", ПараметрОповещения);
		
	КонецЦикла;
	
	Если ТипЗнч(ДополнительныеПараметры.Контекст) = Тип("ТаблицаФормы") Тогда
		
		// Выполнено действие из динамического списка
		ТекстСообщения = СтрШаблон(
			НСтр("ru='Для %1 из %2 выделенных в списке документов выполнено действие: %3'"),
			СоответствиеДокументыСтатусы.Количество(),
			ДополнительныеПараметры.Контекст.ВыделенныеСтроки.Количество(),
			ДополнительныеПараметры.ДальнейшееДействие);
			
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнено действие'"),,
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	ИначеЕсли ЗначениеЗаполнено(ДополнительныеПараметры.Контекст) Тогда
		
		// Выполнено действие из формы документа
		Для Каждого КлючИЗначение Из СоответствиеДокументыСтатусы Цикл
			
			Если КлючИЗначение.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Для документа %1 изменен статус ЕГАИС: %2.'"),
				КлючИЗначение.Ключ,
				КлючИЗначение.Значение);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Выполнено действие'"),
				ПолучитьНавигационнуюСсылку(КлючИЗначение.Ключ),
				ТекстСообщения,
				БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	Иначе
		
		// Выполнен обмен с ЕГАИС
		ДополнительныеПараметрыОповещения = Новый Структура;
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыОснования", СоответствиеДокументыОснования);
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыСтатусы",   СоответствиеДокументыСтатусы);
		ДополнительныеПараметрыОповещения.Вставить("Изменения",                      Изменения);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Изменено объектов: %1'"), СоответствиеДокументыСтатусы.Количество());
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнен обмен с ЕГАИС'"),
			Новый ОписаниеОповещения("ОткрытьРезультатВыполненияОбменаЕГАИС", ИнтеграцияЕГАИССлужебныйКлиент, ДополнительныеПараметрыОповещения),
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Изменения);
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Параметры:
//  ОповещениеПриЗавершении				 - ОписаниеОповещения - процедура которую надо выполнить после передачи всех данных в УТМ
//  ДанныеДляВыполненияОбменаНаКлиенте	 - Структура          - данные для выполнения обмена
//
Процедура ОбработатьОчередьПередачиДанных(ОповещениеПриЗавершении, ДанныеДляВыполненияОбменаНаКлиенте) Экспорт
	
	СообщенияXMLКПередаче = ДанныеДляВыполненияОбменаНаКлиенте.СообщенияXMLКПередаче;
	
	ИдетОбменСЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ИдетОбменСЕГАИС <> Неопределено Тогда 
		Для Каждого ЭлементСообщение Из СообщенияXMLКПередаче Цикл 
			ДанныеДляВыполненияОбменаНаКлиенте.Изменения.Добавить(ЭлементСообщение);
		КонецЦикла;
		СообщенияXMLКПередаче.Очистить();
	КонецЕсли;
	
	Если СообщенияXMLКПередаче.Количество() > 0 Тогда
		
		ДополнительныеПараметры = ОбщиеПараметрыОбменаНаКлиенте(ДанныеДляВыполненияОбменаНаКлиенте);
		ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
		ДополнительныеПараметры.ВОсновнойФорме          = ДанныеДляВыполненияОбменаНаКлиенте.Свойство("ВОсновнойФорме");
		ДополнительныеПараметры.Вставить("РезультатыПередачиСообщенийПоОрганизациямЕГАИС", Новый Соответствие);
		
		ПередатьСообщения(СообщенияXMLКПередаче, ДополнительныеПараметры);
		
	Иначе
		
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ДанныеДляВыполненияОбменаНаКлиенте.Изменения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбработатьСписокВходящихДокументов(ДанныеОбработкиТекстОшибки, Контекст) Экспорт
	
	ДополнительныеПараметры = ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ДополнительныеПараметры.Вставить("ДокументыКЗагрузке", Новый Соответствие);
	
	ПолучитьСообщения(ДанныеОбработкиТекстОшибки.ДанныеОбработки, ДополнительныеПараметры);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ПослеОбработкиОчередиПередачиДанных(Изменения, Контекст) Экспорт
	
	ПараметрыОбработкиСпискаВходящихДокументов = ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ПараметрыОбработкиСпискаВходящихДокументов.Изменения = Изменения;
	
	ОповещениеПриЗавершенииПолученияСпискаВходящихДокументов = Новый ОписаниеОповещения(
		"ОбработатьСписокВходящихДокументов",
		ИнтеграцияЕГАИССлужебныйКлиент,
		ПараметрыОбработкиСпискаВходящихДокументов);
	
	ДополнительныеПараметры = ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ДополнительныеПараметры.Изменения = Изменения;
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершенииПолученияСпискаВходящихДокументов;
	ДополнительныеПараметры.Вставить("Результат",   Новый Соответствие);
	ДополнительныеПараметры.Вставить("ТекстОшибки", "");
	
	ОрганизацииЕГАИС = ИнтеграцияЕГАИСКлиентСервер.ОрганизацииЕГАИС(Контекст.НастройкиОбменаЕГАИС);
	
	ПолучитьСпискиВходящихСообщений(ОрганизацииЕГАИС, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

Процедура ОбработатьОчереднуюПорциюДанных() Экспорт
	ВыполнитьОбработкуОповещения(ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"].ОбработчикОповещения);
КонецПроцедуры

#Область ПередачаДанных

// Только для внутреннего использования.
//
// Запускает очередь обмена с УТМ ЕГАИС (через глобальную переменную ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"]), передача данных
Процедура ПередатьСообщения(СообщенияXML, Контекст)
	
	Если ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена",
		СохраняемыеДанныеОбмена(
			СообщенияXML,
			Контекст,
			Новый ОписаниеОповещения("ПередатьСообщение", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПередачиСообщений", ИнтеграцияЕГАИССлужебныйКлиент)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Выгружает очередной элемент очереди в УТМ
Процедура ПередатьСообщение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ДанныеОбменаЕГАИС.СообщенийXML > ДанныеОбменаЕГАИС.НомерКОбработке Тогда
		ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
		НастройкаОбменаНаКлиенте = ДанныеОбменаЕГАИС.Контекст.НастройкиОбменаЕГАИС.Получить(ПорцияДанных.ОрганизацияЕГАИС);
		
		ПараметрыHTTPЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыHTTPЗапроса(
			ПорцияДанных.ТекстСообщенияXML,
			ПорцияДанных.АдресЗапроса);
		
		ОтправитьHTTPЗапрос(
			Новый ОписаниеОповещения("ПослеПередачиСообщения", ИнтеграцияЕГАИССлужебныйКлиент),
			НастройкаОбменаНаКлиенте,
			ПараметрыHTTPЗапроса);
	Иначе
		
		ВыполнитьОбработкуОповещения(ДанныеОбменаЕГАИС.ДействиеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Оповещение после передачи очередного документа
Процедура ПослеПередачиСообщения(РезультатОтправкиHTTPЗапроса, Контекст) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
	ОрганизацияЕГАИС = ПорцияДанных.ОрганизацияЕГАИС;
	
	ЭлементДанных = Новый Структура;
	ЭлементДанных.Вставить("ИсходящееСообщение",           ПорцияДанных.Ссылка);
	ЭлементДанных.Вставить("РезультатОтправкиHTTPЗапроса", ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса));
	
	Если ДанныеОбменаЕГАИС.Результат.Получить(ОрганизацияЕГАИС) = Неопределено Тогда
		ДанныеОбменаЕГАИС.Результат.Вставить(ОрганизацияЕГАИС, Новый Массив);
	КонецЕсли;
	
	ДанныеОбменаЕГАИС.Результат[ОрганизацияЕГАИС].Добавить(ЭлементДанных);
	
	ДанныеОбменаЕГАИС.НомерКОбработке = ДанныеОбменаЕГАИС.НомерКОбработке + 1;
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Действия после выгрузки очереди в УТМ
Процедура ПослеПередачиСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	Если ДанныеОбменаЕГАИС.Результат.Количество() = 0 Тогда
		ПараметрОповещения = ДанныеОбменаЕГАИС.Результат;
	Иначе
		ПараметрОповещения = ИнтеграцияЕГАИСВызовСервера.ПриЗавершенииПередачиДанных(ДанныеОбменаЕГАИС.Результат);
	КонецЕсли;
	ОповещениеПриЗавершении = ДанныеОбменаЕГАИС.Контекст.ОповещениеПриЗавершении;
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	Если ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ПараметрОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаСписковДокументов

// Только для внутреннего использования.
//
// Запускает очередь обмена с УТМ ЕГАИС (через глобальную переменную ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"]), получение списков входящих документов
Процедура ПолучитьСпискиВходящихСообщений(ОрганизацииЕГАИС, Контекст) Экспорт
	
	Если ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена", 
		СохраняемыеДанныеОбмена(
			ОрганизацииЕГАИС,
			Контекст,
			Новый ОписаниеОповещения("ПолучитьДокументыПоОчереднойОрганизацииИзОчередиОбмена", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПолученияСписковСообщений", ИнтеграцияЕГАИССлужебныйКлиент)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Получает список документов по очередной организации из очереди обмена
Процедура ПолучитьДокументыПоОчереднойОрганизацииИзОчередиОбмена(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ДанныеОбменаЕГАИС.СообщенийXML > ДанныеОбменаЕГАИС.НомерКОбработке Тогда
		ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
		
		ИнтеграцияЕГАИСКлиент.ОбновитьДатуПоследнегоЗапускаОбменаНаКлиентеПоРасписанию(ПорцияДанных);
		
		НастройкаОбменаНаКлиенте = ДанныеОбменаЕГАИС.Контекст.НастройкиОбменаЕГАИС.Получить(ПорцияДанных);
		Если НастройкаОбменаНаКлиенте.ЗагружатьВходящиеДокументы Тогда
			
			ПараметрыHTTPЗапроса = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхHTTPЗапроса("GET", "/opt/out");
			
			ОтправитьHTTPЗапрос(
				Новый ОписаниеОповещения("ПослеПолученияСписка", ИнтеграцияЕГАИССлужебныйКлиент),
				НастройкаОбменаНаКлиенте,
				ПараметрыHTTPЗапроса);
			
		Иначе
			
			ДанныеОбменаЕГАИС.НомерКОбработке = ДанныеОбменаЕГАИС.НомерКОбработке + 1;
			ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
			
		КонецЕсли;
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ДанныеОбменаЕГАИС.ДействиеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Оповещение после получения списка входящих документов очередной организации
Процедура ПослеПолученияСписка(РезультатОтправкиHTTPЗапроса, Контекст) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ОрганизацияЕГАИС = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
	
	РезультатОперации = ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса);
	
	Если РезультатОперации.ТекстСообщенияXMLПолучен Тогда
		
		Если ДанныеОбменаЕГАИС.Результат.Получить(ОрганизацияЕГАИС) = Неопределено Тогда
			ДанныеОбменаЕГАИС.Результат.Вставить(ОрганизацияЕГАИС, Новый Массив);
		КонецЕсли;
		
		ДанныеОбменаЕГАИС.Результат[ОрганизацияЕГАИС].Добавить(РезультатОперации.ТекстВходящегоСообщенияXML);
		
	Иначе
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Не удалось получить список входящих документов организации %1:
			           |По причине:
			           |%2'"),
			ОрганизацияЕГАИС,
			РезультатОперации.ТекстОшибки);
		
		ИнтеграцияЕГАИСКлиентСервер.СообщитьПользователюВФорму(ДанныеОбменаЕГАИС.Контекст.ИдентификаторВладельца, ТекстОшибки);
		
		Если ЗначениеЗаполнено(ДанныеОбменаЕГАИС.ТекстОшибки) Тогда
			ДанныеОбменаЕГАИС.ТекстОшибки = ДанныеОбменаЕГАИС.ТекстОшибки
			                              + Символы.ПС + ТекстОшибки;
		Иначе
			ДанныеОбменаЕГАИС.ТекстОшибки = ТекстОшибки;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеОбменаЕГАИС.НомерКОбработке = ДанныеОбменаЕГАИС.НомерКОбработке + 1;
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Действия после загрузки списков сообщений из УТМ
Процедура ПослеПолученияСписковСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	
	#Если ВебКлиент Тогда
		ДанныеОбработки = ИнтеграцияЕГАИСВызовСервера.ОбработатьОтветНаЗапросПолученияДокументов(ДанныеОбменаЕГАИС.Результат);
	#Иначе
		ДанныеОбработки = ИнтеграцияЕГАИСКлиентСервер.ОбработатьОтветНаЗапросПолученияДокументов(ДанныеОбменаЕГАИС.Результат);
	#КонецЕсли
	
	Результат = НоваяСтруктураСписокВходящихДокументов(
		ДанныеОбработки,
		ДанныеОбменаЕГАИС.Контекст.ТекстОшибки);
	
	Если ЗначениеЗаполнено(ДанныеОбменаЕГАИС.ТекстОшибки) Тогда
		ИнтеграцияЕГАИСКлиентСервер.СообщитьПользователюВФорму(
			ДанныеОбменаЕГАИС.Контекст.ИдентификаторВладельца,
			ДанныеОбменаЕГАИС.ТекстОшибки);
	КонецЕсли;
	
	ОповещениеПриЗавершении = ДанныеОбменаЕГАИС.Контекст.ОповещениеПриЗавершении;
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДокументов

// Только для внутреннего использования.
//
// Запускает очередь обмена с УТМ ЕГАИС (через глобальную переменную ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"]), получение входящих документов
Процедура ПолучитьСообщения(ДанныеДокументовКПолучению, Контекст) Экспорт
	
	Если ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена",
		СохраняемыеДанныеОбмена(
			ДанныеДокументовКПолучению,
			Контекст,
			Новый ОписаниеОповещения("ПолучитьСообщение", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПолученияСообщений", ИнтеграцияЕГАИССлужебныйКлиент)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Получает очередной документ из очереди обмена
Процедура ПолучитьСообщение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ДанныеОбменаЕГАИС.СообщенийXML > ДанныеОбменаЕГАИС.НомерКОбработке Тогда
		ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
		НастройкаОбменаНаКлиенте = ДанныеОбменаЕГАИС.Контекст.НастройкиОбменаЕГАИС.Получить(ПорцияДанных.ОрганизацияЕГАИС);
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(ПорцияДанных.АдресURL);
		
		ПараметрыHTTPЗапроса = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхHTTPЗапроса("GET", СтруктураURI.ПутьНаСервере);
		
		ОтправитьHTTPЗапрос(
			Новый ОписаниеОповещения("ПослеПолученияСообщения", ИнтеграцияЕГАИССлужебныйКлиент),
			НастройкаОбменаНаКлиенте,
			ПараметрыHTTPЗапроса);
	Иначе
		
		ВыполнитьОбработкуОповещения(ДанныеОбменаЕГАИС.ДействиеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Оповещение после получения очередного документа
Процедура ПослеПолученияСообщения(РезультатОтправкиHTTPЗапроса, Контекст) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
	ОрганизацияЕГАИС = ПорцияДанных.ОрганизацияЕГАИС;
	РезультатОперации = ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса);
	
	Если РезультатОперации.ТекстСообщенияXMLПолучен Тогда
		
		Если ДанныеОбменаЕГАИС.Результат.Получить(ОрганизацияЕГАИС) = Неопределено Тогда
			ДанныеОбменаЕГАИС.Результат.Вставить(ОрганизацияЕГАИС, Новый Массив);
		КонецЕсли;
		
		ДанныеОбменаЕГАИС.Результат[ОрганизацияЕГАИС].Добавить(
			ИнтеграцияЕГАИСКлиентСервер.СтруктураЗагрузкиВходящегоДокумента(
				ОрганизацияЕГАИС,
				ПорцияДанных.ИдентификаторЗапроса,
				ПорцияДанных.АдресURL,
				РезультатОперации.ТекстВходящегоСообщенияXML));
		
	КонецЕсли;
	
	ДанныеОбменаЕГАИС.НомерКОбработке = ДанныеОбменаЕГАИС.НомерКОбработке + 1;
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Действия после загрузки документов из УТМ
Процедура ПослеПолученияСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	Контекст = ДанныеОбменаЕГАИС.Контекст;
	Результат = ДанныеОбменаЕГАИС.Результат;
	
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	Если Результат.Количество() = 0 Тогда
		
		Если Контекст.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Контекст.ОповещениеПриЗавершении, Контекст.Изменения);
		КонецЕсли;
		
	Иначе
		
		Результат = ИнтеграцияЕГАИСВызовСервера.ОбработатьВходящиеДокументы(Результат, Контекст.ИдентификаторВладельца);
		
		ДокументыКУдалению = Новый Массив;
		Для Каждого ЭлементДанных Из Результат.Изменения Цикл
			
			Контекст.Изменения.Добавить(ЭлементДанных);
			
			Для Каждого Данные Из ЭлементДанных.СлужебныеДанные Цикл
				ДокументыКУдалению.Добавить(Данные);
			КонецЦикла;
			
		КонецЦикла;
		
		ДополнительныеПараметры = ОбщиеПараметрыОбменаНаКлиенте(Контекст);
		
		ПодтвердитьЗагруженныеСообщения(ДокументыКУдалению, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УдалениеЗагруженныхДокументов

// Только для внутреннего использования.
//
// Запускает очередь обмена с УТМ ЕГАИС (через глобальную переменную ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"]), удаление полученных документов
Процедура ПодтвердитьЗагруженныеСообщения(ДанныеДокументовКУдалению, Контекст)
	
	Если ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена",
		СохраняемыеДанныеОбмена(
			ДанныеДокументовКУдалению,
			Контекст,
			Новый ОписаниеОповещения("ПодтвердитьСообщение", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПодтвержденияСообщений", ИнтеграцияЕГАИССлужебныйКлиент)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Удаляет очередной загруженный документ из очереди обмена
Процедура ПодтвердитьСообщение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ДанныеОбменаЕГАИС.СообщенийXML > ДанныеОбменаЕГАИС.НомерКОбработке Тогда
		
		ПорцияДанных = ДанныеОбменаЕГАИС.СообщенияXML[ДанныеОбменаЕГАИС.НомерКОбработке];
		НастройкаОбменаНаКлиенте = ДанныеОбменаЕГАИС.Контекст.НастройкиОбменаЕГАИС.Получить(ПорцияДанных.ОрганизацияЕГАИС);
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(ПорцияДанных.АдресЗапроса);
		ПараметрыHTTPЗапроса = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхHTTPЗапроса("DELETE", СтруктураURI.ПутьНаСервере);
		
		ОтправитьHTTPЗапрос(
			Новый ОписаниеОповещения("ПослеПодтвержденияСообщения", ИнтеграцияЕГАИССлужебныйКлиент),
			НастройкаОбменаНаКлиенте,
			ПараметрыHTTPЗапроса);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ДанныеОбменаЕГАИС.ДействиеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Оповещение после удаления очередного документа
Процедура ПослеПодтвержденияСообщения(РезультатОтправкиHTTPЗапроса, Контекст) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	
	//результат удаления не контролируется все равно
	ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса);
	
	ДанныеОбменаЕГАИС.НомерКОбработке = ДанныеОбменаЕГАИС.НомерКОбработке + 1;
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Действия после подтверждения получения сообщений
Процедура ПослеПодтвержденияСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	ОповещениеПриЗавершении = ДанныеОбменаЕГАИС.Контекст.ОповещениеПриЗавершении;
	Изменения = ДанныеОбменаЕГАИС.Контекст.Изменения;
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	Если ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Изменения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Только для внутреннего использования.
//
// Параметры:
//  ПакетыОбмена - Массив - массив данных для обмена
//  Контекст     - Структура - контекст вызова (прочие сохраняемые значения)
// 
// Возвращаемое значение:
//  Структура - значения которые будут сохраняться в глобальной переменной на клиенте до окончания обработки всего пакета
//
Функция СохраняемыеДанныеОбмена(ПакетыОбмена, Контекст, ОбработчикОповещения, ДействиеПриЗавершении) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СообщенияXML",          ПакетыОбмена);
	Результат.Вставить("Контекст",              Контекст);
	Результат.Вставить("СообщенийXML",          ПакетыОбмена.Количество());
	Результат.Вставить("НомерКОбработке",       0);
	Результат.Вставить("Результат",             Новый Соответствие);
	Результат.Вставить("ТекстОшибки",           "");
	Результат.Вставить("ОбработчикОповещения",  ОбработчикОповещения);
	Результат.Вставить("ДействиеПриЗавершении", ДействиеПриЗавершении);
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Процедура ОтправитьHTTPЗапрос(ОповещениеПриЗавершении, НастройкаОбменаНаКлиенте, ПараметрыHTTPЗапроса) Экспорт
	
	#Если ВебКлиент Тогда
		ИнтеграцияЕГАИСВебКлиент.НачатьФормированиеHTTPЗапроса(
			ОповещениеПриЗавершении,
			НастройкаОбменаНаКлиенте,
			ПараметрыHTTPЗапроса,
			Ложь);
	#Иначе
		РезультатОтправкиHTTPЗапроса = ИнтеграцияЕГАИСКлиентСервер.ОтправитьHTTPЗапрос(
			НастройкаОбменаНаКлиенте,
			ПараметрыHTTPЗапроса);
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатОтправкиHTTPЗапроса);
	#КонецЕсли
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса) Экспорт
	
	#Если ВебКлиент Тогда
		Возврат ИнтеграцияЕГАИСВызовСервера.ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса);
	#Иначе
		Возврат ИнтеграцияЕГАИСКлиентСервер.ОбработатьРезультатОтправкиHTTPЗапроса(РезультатОтправкиHTTPЗапроса);
	#КонецЕсли
	
КонецФункции

// Только для внутреннего использования.
Функция ОбменУжеЗапущен(Контекст, ВыводитьСообщения = Истина) Экспорт
	
	ИдетОбменСЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	Если ИдетОбменСЕГАИС <> Неопределено Тогда
		Если ВыводитьСообщения Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Обмен с УТМ ЕГАИС уже запущен, дождитесь завершения предыдущего сеанса'"));
		КонецЕсли;
		Возврат Истина;
	КонецЕсли;
	
	Контекст.Вставить("Форма", Неопределено);
	Если Контекст.ВОсновнойФорме = Ложь Тогда
		Контекст.Форма = ОткрытьФорму(
			"ОбщаяФорма.ДлительнаяОперация",
			Новый Структура("ТекстСообщения", НСтр("ru = 'Выполняется обмен с  ЕГАИС'")),,
			"EGAIS3",,,,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	КонецЕсли;
		
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Процедура ЗакрытьФормуВыполненияОбмена(Форма) Экспорт
	
	Если НЕ(Форма = Неопределено) Тогда
		Если Форма.Открыта() Тогда
			Форма.Закрыть();
		КонецЕсли;
		Форма = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ОбщиеПараметрыОбменаНаКлиенте(Источник) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкиОбменаЕГАИС",    Неопределено);
	Результат.Вставить("Изменения",               Неопределено);
	Результат.Вставить("ОповещениеПриЗавершении", Неопределено);
	Результат.Вставить("ИдентификаторВладельца",  Неопределено);
	Результат.Вставить("ВОсновнойФорме",          Истина);
	ЗаполнитьЗначенияСвойств(Результат, Источник);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
