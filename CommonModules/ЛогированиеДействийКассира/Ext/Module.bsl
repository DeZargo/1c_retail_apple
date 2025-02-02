﻿#Область ПрограммныйИнтерфейс

// Записывает действие кассир
//
// Параметры:
//  ВидДействияКассираВРМК  - Строка, идентификатор вида операции кассира в РМК.
//  СтруктураЛога - Структура записываемая в регистр.
//
Процедура ЗаписатьЛогОперации(ВидДействияКассираВРМК, СтруктураЛога) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураЛога.Вставить("ВидДействияКассираВРМК", Перечисления.ВидыДействийКассираВРМК[ВидДействияКассираВРМК]);
	МенеджерЗаписи = РегистрыСведений.ЛогДействийКассираВРМК.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураЛога);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры // ЗаписатьЛогОперации()

// Заполнить предварительные записи лога.
//
// Параметры:
//  ЧекККМ  - Документ.ЧекККМ.Ссылка
//  ИдентификаторФормыПредварительныхДанных - уникальный идентификатор.
//
Процедура ЗаполнитьПредварительныйЛог(ИдентификаторФормыПредварительныхДанных, ЧекККМ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ЛогДействийКассираВРМК.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФормыПредварительныхДанных.Установить(ИдентификаторФормыПредварительныхДанных);
	НаборЗаписей.Прочитать();
	ТаблицаНабораЗаписей = НаборЗаписей.Выгрузить();
	ТаблицаНабораЗаписей.ЗаполнитьЗначения(ЧекККМ, "ЧекККМ");
	НаборЗаписей.Загрузить(ТаблицаНабораЗаписей);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры // ЗаполнитьПредварительныйЛог()

#КонецОбласти