﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ КОНТРОЛЯ УДАЛЕННОГО АДМИНИСТРИРОВАНИЯ
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/RemoteAdministration/Control/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
Функция Версия() Экспорт
	
	Возврат "1.0.2.5";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "RemoteAdministrationControl";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольУдаленногоАдминистрированияОбработчикТрансляции_1_0_2_3);
	МассивОбработчиков.Добавить(СообщенияКонтрольУдаленногоАдминистрированияОбработчикТрансляции_1_0_2_4);
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepared.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбластьДанныхПодготовлена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationPrepared");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationDeleted.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбластьДанныхУдалена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationDeleted");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepareFailed.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОшибкаПодготовкиОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationPrepareFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationPrepareFailedConversionRequired
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОшибкаПодготовкиОбластиДанныхТребуетсяКонвертация(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationPrepareFailedConversionRequired");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationDeleteFailed.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОшибкаУдаленияОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationDeleteFailed");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/RemoteAdministration/Control/a.b.c.d}ApplicationReady.
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеОбластьДанныхГотоваКИспользованию(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ApplicationReady");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
