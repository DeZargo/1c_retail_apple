﻿
&После("ОбработкаПроведения")
Процедура КочетовОбработкаПроведения(Отказ, РежимПроведения)
	
	мен=РегистрыСведений.СтатусыДокументовЕГАИС.СоздатьМенеджерЗаписи();
	мен.Документ=ссылка;
	мен.Прочитать();
	Если мен.Статус=Перечисления.СтатусыОбработкиАктаСписанияЕГАИС.ПроведенЕГАИС Тогда
		
		
		ххх_Сервер.ОтразитьДвиженияАкцизныхМарок(Движения,Ссылка,ВидДвиженияНакопления.Расход);
		
		
	КонецЕсли;
КонецПроцедуры
