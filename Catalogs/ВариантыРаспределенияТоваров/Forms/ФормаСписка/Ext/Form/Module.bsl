﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
   
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
	         Истина, "Справочник.ВариантыРаспределенияТоваров.Форма.ФормаЭлемента.Открытие");
    
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ВариантыРаспределенияТоваров.Форма.ФормаСписка.Открытие");
            
КонецПроцедуры

#КонецОбласти
