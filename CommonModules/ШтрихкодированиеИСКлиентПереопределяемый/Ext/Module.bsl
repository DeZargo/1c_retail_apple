﻿#Область ПрограммныйИнтерфейс

// В процедуре нужно показать диалоговое окно для ввода штрихкода и передать полученные данные в описание оповещения.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - процедура, которую нужно вызвать после ввода штрихкода.
//
Процедура ПоказатьВводШтрихкода(Оповещение) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

// В процедуре необходимо реализовать алгоритм обработки после получения данных по штрихкодам и попытки обработать эти данные.
// 
// Параметры:
// 	Форма - УправляемаяФорма - форма, для которой необходимо выполнить обработку штрихкода.
// 	ОбработанныеДанные - 
// 	КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
Процедура ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения);
	
КонецПроцедуры

// В процедуре необходимо реализовать открытие формы, в которой будет возможность сопоставить неизвестные штрихкоды с номенклатурой.
// 
// Параметры:
// 	НеизвестныеШтрихкоды - Массив - Штрихкоды для сопоставления.
// 	ФормаВладелец - УправляемаяФорма - Форма владелец.
// 	ОповещениеОЗакрытии - ОписаниеОповещения - Оповещение, которое должно быть вызвано после сопоставления номенклатуры.
Процедура ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(НеизвестныеШтрихкоды, ФормаВладелец = Неопределено, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(НеизвестныеШтрихкоды, 
		ФормаВладелец, 
		ОповещениеОЗакрытии);
	
КонецПроцедуры

// В процедуре необходимо реализовать очистку колекции штрихкодов, которые находятся в структуре кэшированные значения.
// 
// Параметры:
// 	ДанныеШтрихкодов - Соответствие - Данные штрихкодов.
// 	КэшированныеЗначения - Структура - Содержит поля кэшируемых значений.
Процедура ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
КонецПроцедуры

// Вызывается после загрузки данных из ТСД. В процедуре нужно проанализировать полученные штрихкоды на предмет сканирования акцизной марки, а также
// обработать штрихкоды, не привязанные к номенклатуре.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
//
Процедура ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения);
	
КонецПроцедуры

// В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов, полученных из ТСД.
//
// Параметры:
//   Форма - УправляемаяФорма - форма документа, в которой происходит обработка,
//   ТаблицаТоваров - Массив - полученные данные из ТСД,
//   КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ,
//   ПараметрыЗаполнения - Структура - параметры заполнения (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти()).
//   СтруктураДействий - Структура - подготовленные данные.
Процедура ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
	Форма, ТаблицаТоваров, КэшированныеЗначения, ПараметрыЗаполнения, СтруктураДействий) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		Форма, 
		ТаблицаТоваров, 
		КэшированныеЗначения, 
		ПараметрыЗаполнения, 
		СтруктураДействий);
	
КонецПроцедуры

// В процедуре необходимо указать полное имя формы выбора серии номенклатуры.
// 
// Параметры:
// 	ПолноеИмяФормыУказанияСерии - Строка - Полное имя формы выбора серии.
Процедура ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии) Экспорт
	
	ШтрихкодированиеИСРТКлиент.ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии);
	
КонецПроцедуры

#КонецОбласти
