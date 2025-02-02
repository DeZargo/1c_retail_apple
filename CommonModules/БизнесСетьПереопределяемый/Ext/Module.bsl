﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создание контрагента в информационной базе по реквизитам.
//
// Параметры:
//   РеквизитыКонтрагента - Структура - реквизиты необходимые для создания контрагента.
//    * ИНН - Строка - ИНН контрагента.
//    * КПП - Строка - КПП контрагента.
//    * Наименование - Строка - наименование контрагента.
//   Контрагент - СправочникСсылка - ссылка на созданного контрагента.
//   Отказ - Булево - признак ошибки.
//
Процедура СоздатьКонтрагентаПоРеквизитам(Знач РеквизитыКонтрагента, Контрагент, Отказ = Ложь) Экспорт
	
	БизнесСетьРТ.СоздатьКонтрагентаПоРеквизитам(РеквизитыКонтрагента, Контрагент, Отказ)
	
КонецПроцедуры

// Возвращает контакты пользователя для регистрации в сервисе.
//
// Параметры:
//   КонтактноеЛицо - СправочникСсылка - пользователь программы, контактное лицо.
//   Результат - Структура - информация о пользователе:
//     * ФИО - Строка - ФИО пользователя.
//     * Телефон - Строка - номер телефона.
//     * ЭлектроннаяПочта - Строка - адрес электронной почты пользователя.
//
Процедура ПолучитьКонтактнуюИнформациюПользователя(Знач КонтактноеЛицо, Результат) Экспорт
	
	БизнесСетьРТ.ПолучитьКонтактнуюИнформациюПользователя(КонтактноеЛицо, Результат)
	
КонецПроцедуры

// Проверка соответствия реквизитов в документах.
//
// Параметры:
//   ДокументыКонтроля - Массив - проверяемые ссылки объектов.
//   ТекстСообщения - Строка - текст сообщения в случае ошибки проверки.
//   Отказ - Булево - результат проверки.
//
Процедура ВыполнитьКонтрольРеквизитовДокументов(Знач ДокументыКонтроля, ТекстСообщения, Отказ) Экспорт

	
КонецПроцедуры

// Получение списка контрагентов по сделкам для отправки приглашений.
//
// Параметры:
//  Организация			 - СправочникСсылка - ссылка на организацию, от которой производится приглашение.
//  РежимЗаполнения		 - Строка - режим заполнения контрагентов: "ЗаполнитьПоПоставкам", "ЗаполнитьПоЗакупкам", "ЗаполнитьПоВсемСделкам".
//  НачалоПериода		 - Дата - начало периода заполнения.
//  СписокКонтрагентов	 - ТаблицаЗначений - список контрагентов:
//    * Ссылка - СправочникСсылка - контрагент.
//    * ЭлектроннаяПочта - Строка - адрес электронной почты.
//
Процедура ПолучитьКонтрагентовПоСделкам(Знач Организация, Знач РежимЗаполнения, Знач НачалоПериода, СписокКонтрагентов) Экспорт

	
КонецПроцедуры

#КонецОбласти
