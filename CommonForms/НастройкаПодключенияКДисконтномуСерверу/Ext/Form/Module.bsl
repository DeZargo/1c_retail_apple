﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.АдресДисконтногоСервера.СписокВыбора.Добавить(
		"http://localhost/ИмяСервиса/ws/DiscountService.1cws?wsdl",
		НСтр("ru = 'Шаблон адреса сервера'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(НаборКонстант.АдресДисконтногоСервера) Тогда
		СтрокаСобщения = НСтр("ru = 'Не заполнен адрес дисконтного сервера'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСобщения, , "АдресДисконтногоСервера", "НаборКонстант");
		Отказ = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключениеКДисконтномуСерверу(Команда)
	
	РезультатПроверки = ПроверитьПодключениеКДисконтномуСерверуНаСервере();
	Если РезультатПроверки Тогда
		ТекстПроверки = НСтр("ru = 'Подключение успешно установлено'");
		ПоказатьПредупреждение(, ТекстПроверки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьПодключениеКДисконтномуСерверуНаСервере()
	
	ПодключениеУспешно = Ложь;
	Если НЕ ЗначениеЗаполнено(НаборКонстант.АдресДисконтногоСервера) Тогда
		СтрокаСобщения = НСтр("ru = 'Не заполнен адрес дисконтного сервера'");
		ОбщегоНазначения.СообщитьПользователю(СтрокаСобщения, , "АдресДисконтногоСервера", "НаборКонстант");
		Возврат ПодключениеУспешно;
	КонецЕсли;
	
	Попытка
		
		Пользователь = ?(ЗначениеЗаполнено(НаборКонстант.ПользовательДисконтногоСервера), НаборКонстант.ПользовательДисконтногоСервера, Неопределено);
		Пароль = ?(ЗначениеЗаполнено(НаборКонстант.ПарольДисконтногоСервера), НаборКонстант.ПарольДисконтногоСервера, Неопределено);
		ТаймаутСервера = НаборКонстант.ТаймаутПодключенияКДисконтномуСерверу;
		ТаймаутПроверки = НаборКонстант.ТаймаутПроверочногоПодключенияКДисконтномуСерверу;
		ИнтернетПрокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси("HTTP");
		
		// Таймаут для определения отдельный.
		Определения = Новый WSОпределения(НаборКонстант.АдресДисконтногоСервера, Пользователь, Пароль, ИнтернетПрокси, ТаймаутПроверки);
		// Таймаут для прокси задан в константе.
		ДисконтныйПрокси = Новый WSПрокси(Определения, "http://localhost/rt2discountservice", "ДисконтныйСервер", "ДисконтныйСерверSoap", ИнтернетПрокси, ТаймаутСервера);
		Если ЗначениеЗаполнено(Пользователь) Тогда
			ДисконтныйПрокси.Пользователь = Пользователь;
			Если ЗначениеЗаполнено(Пароль) Тогда
				ДисконтныйПрокси.Пароль = Пароль;
			КонецЕсли;
		КонецЕсли;
	
		ИдентификаторКарты = Строка(Справочники.ИнформационныеКарты.ПустаяСсылка().УникальныйИдентификатор());
		ДатаНачалаЗапроса = ТекущаяДатаСеанса();
		ДатаОкончанияЗапроса = ДатаНачалаЗапроса;
		ИдентификаторСегмента = "";
		ИдентификаторИсключаемогоДокумента = "";
		ЗапросДанныеНакоплений = ДисконтныйПрокси.ПолучитьСуммуНакопления(ИдентификаторКарты,
											ДатаНачалаЗапроса,
											ДатаОкончанияЗапроса,
											ИдентификаторСегмента,
											ИдентификаторИсключаемогоДокумента);
		ПодключениеУспешно = Истина;
		
	Исключение
		СтрокаОшибки = НСтр("ru = 'Не удалось подключиться к дисконтному серверу по причине:");
		ПодробностиОшибки = СтрокаОшибки + Символы.ПС + ОписаниеОшибки();
		ИмяСобытия = НСтр("ru = 'Дисконтный сервер'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробностиОшибки);
		ОбщегоНазначения.СообщитьПользователю(
			ПодробностиОшибки,
			,
			"АдресДисконтногоСервера",
			"НаборКонстант");
	КонецПопытки;
	
	Возврат ПодключениеУспешно;
	
КонецФункции

#КонецОбласти
