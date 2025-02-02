﻿#Область ПеременныеМодуля

Перем СоответствиеЗаголовка Экспорт; // Хранит заголовки страниц
Перем СоответствиеОкончанияНаименования Экспорт; // Хранит окончания наименования заголовков страниц.

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура заполнения соответствий наименований типов оборудования.
//
Процедура ЗаполнитьСоответствияСообщений() Экспорт
	
	СоответствиеЗаголовка = Новый Соответствие;
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода         , НСтр("ru = 'Сканер штрихкодов'"));
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт, НСтр("ru = 'Считыватель магнитных карт'"));
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор   , НСтр("ru = 'Фискальный регистратор'"));
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал   , НСтр("ru = 'Эквайринговый терминал'"));
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя       , НСтр("ru = 'Дисплей покупателя'"));
	СоответствиеЗаголовка.Вставить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы         , НСтр("ru = 'Электронные весы (online)'"));
	
	СоответствиеОкончанияНаименования = Новый Соответствие;
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода         , НСтр("ru = 'сканер'"));
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт, НСтр("ru = 'ридер'"));
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор   , НСтр("ru = 'фискальный регистратор'"));
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал   , НСтр("ru = 'эквайринговый терминал'"));
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя       , НСтр("ru = 'дисплей покупателя'"));
	СоответствиеОкончанияНаименования.Вставить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы         , НСтр("ru = 'весы-online'"));
	
КонецПроцедуры

#КонецОбласти
