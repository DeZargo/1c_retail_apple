﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданиеФорматаЗаписиКодаМагнитныхКарт" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ФорматыЗаписиКодовМагнитныхКарт.Форма.ФормаЗаписи.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ФорматыЗаписиКодовМагнитныхКарт.Форма.ФормаСписка.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "ОткрытьПомощникНастройки".
//
&НаКлиенте
Процедура ОткрытьПомощникНастройки(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ФорматыЗаписиКодовМагнитныхКарт.Форма.ФормаПомощникаСозданияЗаписи.Открытие");
	
	ОткрытьФорму("РегистрСведений.ФорматыЗаписиКодовМагнитныхКарт.Форма.ФормаПомощникаСозданияЗаписи",, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти
