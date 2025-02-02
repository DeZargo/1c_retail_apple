﻿
&НаКлиенте
Процедура КочетовЗаписатьАкцизиВместо(Команда)
	КочетовЗаписатьАкцизиВместоНаСервере();
КонецПроцедуры

&НаСервере
Процедура КочетовЗаписатьАкцизиВместоНаСервере()
	// Вставить содержимое обработчика.

	
	Для каждого стр из Объект.АкцизныеМарки Цикл
		
		Если ЗначениеЗаполнено(стр.ИдентификаторСтроки) Тогда 
		
			мен=РегистрыСведений.АкцизныеМаркиЕГАИС.СоздатьМенеджерЗаписи();
			мен.АкцизнаяМарка=стр.АкцизнаяМарка;
			
			
			отбор=Новый Структура;
			отбор.Вставить("ИдентификаторСтроки",стр.ИдентификаторСтроки);
			стрТов=Объект.Товары.НайтиСтроки(отбор);
			
			мен.Справка2=стрТов[0].Справка2;//стр.Справка2.АлкогольнаяПродукция;
			мен.АлкогольнаяПродукция=стрТов[0].Справка2.АлкогольнаяПродукция;//стр.Справка2;
			
			
			
			мен.Статус=перечисления.СтатусыАкцизныхМарок.КПостановкеНаБаланс;
			мен.организацияЕГАИС=объект.ОрганизацияЕГАИС;
			
			мен.Записать();
			
		ИначеЕсли ЗначениеЗаполнено(стр.Справка2) Тогда 
		
			мен=РегистрыСведений.АкцизныеМаркиЕГАИС.СоздатьМенеджерЗаписи();
			мен.АкцизнаяМарка=стр.АкцизнаяМарка;
			мен.Прочитать();
			
			Если ЗначениеЗаполнено(мен.Статус) и не мен.Статус=Перечисления.СтатусыАкцизныхМарок.КПостановкеНаБаланс Тогда
				продолжить;
			КонецЕсли;
			
			мен.АкцизнаяМарка=стр.АкцизнаяМарка;
			отбор=Новый Структура;
			отбор.Вставить("Справка2",стр.Справка2);
			стрТов=Объект.Товары.НайтиСтроки(отбор);
			
			мен.Справка2=стрТов[0].Справка2;//стр.Справка2.АлкогольнаяПродукция;
			мен.АлкогольнаяПродукция=стрТов[0].Справка2.АлкогольнаяПродукция;//стр.Справка2;
			
			
			
			мен.Статус=перечисления.СтатусыАкцизныхМарок.КПостановкеНаБаланс;
			мен.организацияЕГАИС=объект.ОрганизацияЕГАИС;
			
			мен.Записать();

		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
&После("НастроитьЭлементыФормы")
Процедура КочетовНастроитьЭлементыФормы(Форма)
	
	АктПостановкиНаБалансУСебя = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ххх_АктФиксацииМарок");
	Форма.Элементы.Операция.СписокВыбора.Добавить(АктПостановкиНаБалансУСебя, НСтр("ru = 'Фиксация марок для отправки на кассы'"));
	
КонецПроцедуры
