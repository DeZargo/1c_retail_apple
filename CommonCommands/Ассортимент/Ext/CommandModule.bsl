﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Документ.ИзменениеАссортимента.Форма.ФормаСписка.Открытие");

    
	ОткрытьФорму("Документ.ИзменениеАссортимента.ФормаСписка",,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
