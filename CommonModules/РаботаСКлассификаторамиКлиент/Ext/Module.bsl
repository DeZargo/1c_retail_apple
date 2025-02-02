﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаСКлассификаторами".
// ОбщийМодуль.РаботаСКлассификаторамиКлиент.
//
// Клиентские процедуры и функции загрузки классификаторов:
//  - обработка событий панели Интернет-поддержка и сервисы.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает помощник обновления классификаторов.
//
Процедура ОбновитьКлассификаторы() Экспорт
	
	ОткрытьФорму("Обработка.ОбновлениеКлассификаторов.Форма.Форма");
	
КонецПроцедуры

// Обработчик команды БИПОбновлениеКлассификаторов
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//  Форма - УправляемаяФорма - форма панели администрирования;
//  Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_ОбновлениеКлассификаторов(Форма, Команда) Экспорт
	
	ОбновитьКлассификаторы();
	
КонецПроцедуры

// Определяет имя события, которое будет содержать оповещение
// о завершении загрузки классификаторов.
//
// Возвращаемое значение:
//  Строка - Имя события. Может быть использовано для идентификации
//           сообщений принимающими их формами.
//
Функция ИмяСобытияОповещенияОЗагрузки() Экспорт
	
	Возврат "РаботаСКлассификаторами.ЗагруженыКлассификаторы";
	
КонецФункции

#КонецОбласти
