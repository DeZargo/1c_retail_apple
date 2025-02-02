﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
// Параметры:
//  КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения - Произвольный - Тело полученного сообщения. В обработчике события тело сообщения может
//                                 быть изменено, например, дополнено информацией.
//  ОбъектСообщения - Произвольные - Объект получаемого сообщения.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
// Параметры:
//  КаналСообщений - Строка - идентификатор канала сообщений, в который отправляется сообщение.
//  ТелоСообщения - Произвольный - тело отправляемого сообщения. В обработчике события тело сообщения
//    может быть изменено, например, дополнено информацией.
//  ОбъектСообщения - Произвольные - Объект отправляемого сообщения.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
КонецПроцедуры

// Процедура вызывается при начале обработки входящего сообщения.
//
// Параметры:
//  Сообщение - ОбъектXDTO - входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение.
//
Процедура ПриНачалеОбработкиСообщения(Знач Сообщение, Знач Отправитель) Экспорт
	
КонецПроцедуры

// Процедура вызывается после обработки входящего сообщения.
//
// Параметры:
//  Сообщение - ОбъектXDTO - входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение,
//  СообщениеОбработано - Булево - Флаг того, что сообщение было успешно обработано. Если значение
//    установлено равным Ложь - после выполнения этой процедуры будет вызвано исключение. В данной
//    процедуре значение данного параметра может быть изменено.
//
Процедура ПослеОбработкиСообщения(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
КонецПроцедуры

// Процедура вызывается при возникновении ошибки обработки сообщения.
//
// Параметры:
//  Сообщение - ОбъектXDTO - входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующей
//    информационной базе, отправившей сообщение.
//
Процедура ПриОшибкеОбработкиСообщения(Знач Сообщение, Знач Отправитель) Экспорт
	
КонецПроцедуры

#КонецОбласти
