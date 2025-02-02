﻿
#Область СлужебныйПрограммныйИнтерфейс

// Параметры соединения к сервисам.
//
// Параметры:
//  ИмяСервиса	 - Строка - имя сервиса "БизнесСеть", "Рубрикатор", "ТорговыеПредложения"
// 
// Возвращаемое значение:
//  Структура - параметры соединения:
//   * Сервер - Строка - имя сервера.
//   * Порт - Число - порт соединения.
//   * Аутентификация - Булево - требуется аутентификация по токену.
//   * Таймаут - Число - длительность ожидания ответа в секундах.
//   * ЗащищенноеСоединение - ЗащищенноеСоединениеOpenSSL - объект защищенного соединения OpenSSL.
//   * Прокси - ИнтернетПрокси - параметры прокси-сервера.
//   * ИдентификаторПрограммы - Строка - уникальный идентификатор информационной базы.
//
Функция ПараметрыСоединения(ИмяСервиса) Экспорт

	Если ИмяСервиса = "БизнесСеть" Тогда
		ПараметрыСоединения = НовыйПараметрыСоединения("1cbn.ru", 443, Истина);
		ПараметрыСоединения.Аутентификация = Истина;
		ПараметрыСоединения.Таймаут = 30;
	ИначеЕсли ИмяСервиса = "Рубрикатор" Тогда
		ПараметрыСоединения = НовыйПараметрыСоединения("1cbn.ru", 443, Истина);
		ПараметрыСоединения.Аутентификация = Ложь;
		ПараметрыСоединения.Таймаут = 30;
	ИначеЕсли ИмяСервиса = "ТорговаяПлощадка" Или ИмяСервиса = "ТорговыеПредложения" Тогда
		ПараметрыСоединения = НовыйПараметрыСоединения("api.1cbn.ru", 443, Истина);
		ПараметрыСоединения.Аутентификация = Истина;
		ПараметрыСоединения.Таймаут = 30;
	КонецЕсли;
	
	Возврат ПараметрыСоединения;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйПараметрыСоединения(Сервер = "", Порт = 80, ЗащищенноеСоединение = Ложь)

	Результат = Новый Структура;
	Результат.Вставить("Сервер",         Сервер);
	Результат.Вставить("Порт",           Порт);
	Результат.Вставить("Аутентификация", Ложь);
	Результат.Вставить("Таймаут",        30);
	Результат.Вставить("Прокси",         Неопределено);
	Результат.Вставить("ЗащищенноеСоединение", Неопределено);
	Результат.Вставить("ИдентификаторПрограммы", Неопределено);
	
	Если ЗащищенноеСоединение Тогда
		Результат.ЗащищенноеСоединение =
			Новый ЗащищенноеСоединениеOpenSSL(, Новый СертификатыУдостоверяющихЦентровОС);
		Результат.Прокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("https");
	Иначе
		Результат.Прокси = ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси("http");
	КонецЕсли;
	
	Результат.ИдентификаторПрограммы = ИдентификаторПрограммы();
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторПрограммы()
	
	Если ОбщегоНазначения.РазделениеВключено() И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получить идентификатор программы.
	Результат = Неопределено;
	УстановитьПривилегированныйРежим(Истина);
	СсылкаИдентификатор = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПользователиБизнесСеть");
	
	// Очистка кэшей.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПользователиБизнесСеть.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.ПользователиБизнесСеть КАК ПользователиБизнесСеть";
	Если Запрос.Выполнить().Пустой() Тогда
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(СсылкаИдентификатор, "ПарольБизнесСеть");
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Пользователи.ТекущийПользователь(), "ТорговыеПредложенияТикет");
		// Очистка зарегистрированных организаций.
		НаборЗаписей = РегистрыСведений.ОрганизацииБизнесСеть.СоздатьНаборЗаписей();
		НаборЗаписей.Записать();
	Иначе
		Результат = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(СсылкаИдентификатор, "ПарольБизнесСеть");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти