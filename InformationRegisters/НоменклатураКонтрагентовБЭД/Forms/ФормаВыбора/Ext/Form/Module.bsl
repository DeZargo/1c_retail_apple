﻿////////////////////////////////////////////////////////////////////////////////
// Модуль формы РегистрСведений.НоменклатураКонтрагентовБЭД.ФормаВыбора
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ВладелецНоменклатуры") Тогда
		
		УстановитьОтборПоВладельцуНоменклатуры(Параметры.ВладелецНоменклатуры);
		
	КонецЕсли;
	
	УстановитьСвойстваПереопределяемыхЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Данные = ДанныеРегистраПоКлючуЗаписи(ВыбраннаяСтрока);
	
	ОповеститьОВыборе(Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	КлючЗаписи = Элементы.Список.ТекущаяСтрока;
	Если КлючЗаписи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ДанныеРегистраПоКлючуЗаписи(КлючЗаписи);
	
	ОповеститьОВыборе(Данные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоВладельцуНоменклатуры(Знач Владелец)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"Владелец", Владелец, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеРегистраПоКлючуЗаписи(Знач КлючЗаписи)
	
	Данные = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НоменклатураКонтрагентовБЭД.Владелец,
	|	НоменклатураКонтрагентовБЭД.Идентификатор,
	|	НоменклатураКонтрагентовБЭД.Наименование,
	|	НоменклатураКонтрагентовБЭД.НаименованиеХарактеристики,
	|	НоменклатураКонтрагентовБЭД.ЕдиницаИзмерения,
	|	НоменклатураКонтрагентовБЭД.Артикул,
	|	НоменклатураКонтрагентовБЭД.Штрихкод,
	|	НоменклатураКонтрагентовБЭД.ИдентификаторНоменклатурыСервиса,
	|	НоменклатураКонтрагентовБЭД.ИдентификаторХарактеристикиСервиса,
	|	НоменклатураКонтрагентовБЭД.Номенклатура,
	|	НоменклатураКонтрагентовБЭД.Характеристика,
	|	НоменклатураКонтрагентовБЭД.Упаковка
	|ИЗ
	|	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	|ГДЕ
	|	НоменклатураКонтрагентовБЭД.Владелец = &Владелец
	|	И НоменклатураКонтрагентовБЭД.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Владелец", КлючЗаписи.Владелец);
	Запрос.УстановитьПараметр("Идентификатор", КлючЗаписи.Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Выборка.Следующий() Тогда
		
		Данные = Новый Структура;
		НоменклатураКонтрагента = ОбменСКонтрагентамиСлужебныйКлиентСервер.НоваяНоменклатураКонтрагента();
		НоменклатураКонтрагента.Владелец = Выборка.Владелец;
		НоменклатураКонтрагента.Идентификатор = Выборка.Идентификатор;
		НоменклатураКонтрагента.Наименование = Выборка.Наименование;
		НоменклатураКонтрагента.Характеристика = Выборка.НаименованиеХарактеристики;
		НоменклатураКонтрагента.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
		НоменклатураКонтрагента.Артикул = Выборка.Артикул;
		НоменклатураКонтрагента.Штрихкод = Выборка.Штрихкод;
		НоменклатураКонтрагента.ИдентификаторНоменклатурыСервиса = Выборка.ИдентификаторНоменклатурыСервиса;
		НоменклатураКонтрагента.ИдентификаторХарактеристикиСервиса = Выборка.ИдентификаторХарактеристикиСервиса;
		
		НоменклатураИБ = ОбменСКонтрагентамиСлужебныйКлиентСервер.НоваяНоменклатураИнформационнойБазы(
			Выборка.Номенклатура, Выборка.Характеристика, Выборка.Упаковка);
			
		Данные.Вставить("НоменклатураКонтрагента", НоменклатураКонтрагента);
		Данные.Вставить("НоменклатураИБ", НоменклатураИБ);
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

&НаСервере
Процедура УстановитьСвойстваПереопределяемыхЭлементовФормы()
	
	МетаданныеСопоставления = ОбменСКонтрагентамиСлужебный.МетаданныеСопоставленияНоменклатуры();
	
	Заголовок = МетаданныеСопоставления.НоменклатураКонтрагентаПредставлениеСписка;
	Элементы.Владелец.Заголовок = МетаданныеСопоставления.ВладелецНоменклатурыПредставлениеОбъекта;
	Элементы.Номенклатура.Заголовок = МетаданныеСопоставления.НоменклатураПредставлениеОбъекта;
	Элементы.Характеристика.Заголовок = МетаданныеСопоставления.ХарактеристикаПредставлениеОбъекта;
	Элементы.Упаковка.Заголовок = МетаданныеСопоставления.УпаковкаПредставлениеОбъекта;
	
КонецПроцедуры

#КонецОбласти