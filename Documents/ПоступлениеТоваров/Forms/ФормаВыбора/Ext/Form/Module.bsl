﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТолькоБезТТН_ЕГАИС") Тогда		
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "ТТНВходящаяЕГАИС", Документы.ТТНВходящаяЕГАИС.ПустаяСсылка(), Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти
