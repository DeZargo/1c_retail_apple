﻿
#Область JSON

// Получить из текста JSON структуру.
// 
// Параметры:
// 	ТекстJSON                    - Строка - Текст JSON.
// 	ПреобразовыватьВСоответствие - Булево - Признак преобразования в соответствие.
// Возвращаемое значение:
// 	Структура, Неопределено - Результат преобразования JSON.
Функция ТекстJSONВОбъект(ТекстJSON, ПреобразовыватьВСоответствие = Ложь) Экспорт
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТекстJSON);
	
	Попытка
		РезультатРазбора = ПрочитатьJSON(Чтение, ПреобразовыватьВСоответствие);
	Исключение
		РезультатРазбора = Неопределено;
	КонецПопытки;
	
	Возврат РезультатРазбора
	
КонецФункции

// Формирует из структуры текст JSON
// 
// Параметры:
// 	Структура - Структура - Произвольная структура данных
// Возвращаемое значение:
// 	Строка - Текст JSON
Функция ОбъектВТекстJSON(Структура) Экспорт
	
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, "  ");
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	
	ЗаписатьJSON(ЗаписьJSON, Структура);
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

#КонецОбласти

#Область HTTPЗапросы

// Структура результата HTTP запроса
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Результат HTTP-запроса:
// * КодСостояния - Число        - Код состояния HTTP
// * Заголовки    - Соответствие - Заголовки HTTP ответа
// * ТекстОтвета  - Строка       - Текст ответа
// * ТекстОшибки  - Строка       - Текст ошибки
Функция РезультатHTTPЗапроса() Экспорт
	
	РезультатHTTPЗапроса = Новый Структура;
	РезультатHTTPЗапроса.Вставить("КодСостояния");
	РезультатHTTPЗапроса.Вставить("Заголовки");
	РезультатHTTPЗапроса.Вставить("ТекстОтвета");
	РезультатHTTPЗапроса.Вставить("ТекстОшибки");	
	
	Возврат РезультатHTTPЗапроса;
	
КонецФункции

// Инициализирует структуру результата обработки HTTP-запроса после получения ответа.
// 
// Параметры:
// 	ТекстВходящегоСообщенияJSON - Строка - Текст входящего сообщения.
// 	КодСостояния                - Число  - Код состояния.
// 
// Возвращаемое значение:
// Структура - Структура со свойствами:
//   ЗапросОтправлен             - Булево - признак того, что сообщеие отправлено.
//   ОтветПолучен                - Булево - признак того, что сообщение обработано сервером.
//   КодСостояния                - Число  - Код состояния HTTP-запроса.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
//
Функция HTTPОтветПолучен(ТекстВходящегоСообщенияJSON, КодСостояния = 200, КакФайл = Ложь)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЗапросОтправлен",             Истина);
	ВозвращаемоеЗначение.Вставить("ОтветПолучен",                Истина);
	
	ВозвращаемоеЗначение.Вставить("КодСостояния",                КодСостояния);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",                 "");
	
	Если КакФайл Тогда
		ВозвращаемоеЗначение.Вставить("ИмяФайла",                    ТекстВходящегоСообщенияJSON);
	Иначе
		Объект = ТекстJSONВОбъект(ТекстВходящегоСообщенияJSON, Истина);
		Если Объект <> Неопределено Тогда
			ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", ОбъектВТекстJSON(Объект));
		Иначе
			ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", ТекстВходящегоСообщенияJSON);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Инициализирует структуру результата обработки HTTP-запроса после отправки сообщения, но до получения ответа.
// 
// Возвращаемое значение:
// Структура:
//   ЗапросОтправлен             - Булево - признак того, что сообщеие отправлено.
//   ОтветПолучен                - Булево - признак того, что сообщение получено.
//   КодСостояния                - Число  - Код состояния HTTP-запроса.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
//
Функция HTTPОтветНеПолучен(Ошибка, ЗапросОтправлен, КодСостояния = Неопределено, КакФайл = Ложь)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЗапросОтправлен",             ЗапросОтправлен);
	ВозвращаемоеЗначение.Вставить("ОтветПолучен",                Ложь);
	
	ВозвращаемоеЗначение.Вставить("КодСостояния",                КодСостояния);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",                 Строка(Ошибка));
	
	Если КакФайл Тогда
		ВозвращаемоеЗначение.Вставить("ИмяФайла", "");
	Иначе
		ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", "");
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Обработать результат отправки HTTP-запроса к сервису ИС МОТП.
// 
// Параметры:
// 	HTTPОтвет   - HTTPОтвет - HTTP-ответ
// 	ТекстОшибки - Строка    - Текст ошибки
// Возвращаемое значение:
// Структура - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен             - Булево - признак того, что сообщеие отправлено.
//  * ОтветПолучен                - Булево - признак того, что сообщение получено.
//  * КодСостояния                - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//  * ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
Функция ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(HTTPОтвет, Знач ТекстОшибки) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	РезультатОтправкиHTTPЗапроса = ИнтерфейсМОТПСлужебный.РезультатHTTPЗапроса();
	РезультатОтправкиHTTPЗапроса.ТекстОшибки = ТекстОшибки;
	Если HTTPОтвет <> Неопределено Тогда
		РезультатОтправкиHTTPЗапроса.КодСостояния = HTTPОтвет.КодСостояния;
		РезультатОтправкиHTTPЗапроса.Заголовки    = HTTPОтвет.Заголовки;
		РезультатОтправкиHTTPЗапроса.ТекстОтвета  = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	КодСостояния = РезультатОтправкиHTTPЗапроса.КодСостояния;
	ТекстОтвета  = РезультатОтправкиHTTPЗапроса.ТекстОтвета;
	
	Если ЗначениеЗаполнено(ТекстОтвета) Тогда
		
		ВозвращаемоеЗначение = HTTPОтветПолучен(ТекстОтвета, КодСостояния);
		
	Иначе
		
		Если Не ЗначениеЗаполнено(КодСостояния) Тогда
			ТекстСообщенияXMLОтправлен = Ложь;
			ЗаголовокОшибки = НСтр("ru = 'HTTP-запрос не отправлен.'");
		Иначе
			ТекстСообщенияXMLОтправлен = Истина;
			ЗаголовокОшибки = СтрШаблон(НСтр("ru = 'Код состояния HTTP: %1.'"), КодСостояния);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОшибки) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + РезультатОтправкиHTTPЗапроса.ТекстОшибки;
		Иначе
			ТекстОшибки = ЗаголовокОшибки;
		КонецЕсли;
		
		ВозвращаемоеЗначение = HTTPОтветНеПолучен(
			ТекстОшибки,
			ТекстСообщенияXMLОтправлен,
			КодСостояния);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Обработать результат отправки HTTP-запроса к сервису ИС МОТП.
// 
// Параметры:
// 	HTTPОтвет   - HTTPОтвет - HTTP-ответ
// 	ТекстОшибки - Строка    - Текст ошибки
// Возвращаемое значение:
// Структура - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен - Булево - признак того, что сообщеие отправлено.
//  * ОтветПолучен    - Булево - признак того, что сообщение получено.
//  * КодСостояния    - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки     - Строка - текст ошибки, если таковая возникла.
//  * ИмяФайла        - Строка - ИмяФайла.
Функция ОбработатьРезультатОтправкиHTTPЗапросаКакФайл(HTTPОтвет, Знач ТекстОшибки) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	РезультатОтправкиHTTPЗапроса = ИнтерфейсМОТПСлужебный.РезультатHTTPЗапроса();
	РезультатОтправкиHTTPЗапроса.ТекстОшибки = ТекстОшибки;
	Если HTTPОтвет <> Неопределено Тогда
		РезультатОтправкиHTTPЗапроса.КодСостояния = HTTPОтвет.КодСостояния;
		РезультатОтправкиHTTPЗапроса.Заголовки    = HTTPОтвет.Заголовки;
		РезультатОтправкиHTTPЗапроса.ТекстОтвета  = HTTPОтвет.ПолучитьИмяФайлаТела();
	КонецЕсли;
	
	КодСостояния = РезультатОтправкиHTTPЗапроса.КодСостояния;
	ТекстОтвета  = РезультатОтправкиHTTPЗапроса.ТекстОтвета;
	
	Если ЗначениеЗаполнено(ТекстОтвета) Тогда
		
		ВозвращаемоеЗначение = HTTPОтветПолучен(ТекстОтвета, КодСостояния, Истина);
		
	Иначе
		
		Если Не ЗначениеЗаполнено(КодСостояния) Тогда
			ТекстСообщенияXMLОтправлен = Ложь;
			ЗаголовокОшибки = НСтр("ru = 'HTTP-запрос не отправлен.'");
		Иначе
			ТекстСообщенияXMLОтправлен = Истина;
			ЗаголовокОшибки = СтрШаблон(НСтр("ru = 'Код состояния HTTP: %1.'"), КодСостояния);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОшибки) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + РезультатОтправкиHTTPЗапроса.ТекстОшибки;
		Иначе
			ТекстОшибки = ЗаголовокОшибки;
		КонецЕсли;
		
		ВозвращаемоеЗначение = HTTPОтветНеПолучен(
			ТекстОшибки,
			ТекстСообщенияXMLОтправлен,
			КодСостояния,
			Истина);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает адрес сервера ИС МОТП.
// 
// Параметры:
// Возвращаемое значение:
// 	Строка - адрес сервера ИС МОТП.
Функция АдресСервера() Экспорт
	
	Возврат "ismotp.crptech.ru";
	
КонецФункции

#КонецОбласти

#Область Прочее

// Сформировать текст ошибки по результату отправки запроса.
// 
// Параметры:
// 	Заголовок - Строка - Заголовок ошибки, например: Параметры авторизации не получены из ИС МОТП.
//  РезультатОтправкиЗапроса - Структруа - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен             - Булево - признак того, что сообщеие отправлено.
//  * ОтветПолучен                - Булево - признак того, что сообщение получено.
//  * КодСостояния                - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//  * ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
// Возвращаемое значение:
// 	Строка - Текст ошибки.
Функция ТекстОшибкиПоРезультатуОтправкиЗапроса(Заголовок, РезультатОтправкиЗапроса) Экспорт
	
	ТекстОшибки = СтрШаблон(
		НСтр("ru='%1.
			     |Код состояния HTTP: %2.
			     |Текст ошибки: %3'"),
		Заголовок,
		РезультатОтправкиЗапроса.КодСостояния,
		РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
	
	Возврат ТекстОшибки;
	
КонецФункции

// Выполняет попытку обновления ключа сессии на сервере
// (на сервере предприятия должны быть установлены сертификаты для подписания и пароль).
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации, Неопределено - Организация для которой необходимо обновить ключ сессии.
// Возвращаемое значение:
// 	Булево - Истина, если обновление ключа сессии выполнено успешно.
Функция ОбновитьКлючСессииНаСервере(Организация = Неопределено) Экспорт
	
	СертификатыДляПодписанияНаСервере = ИнтеграцияМОТП.СертификатыДляПодписанияНаСервере();
	Если СертификатыДляПодписанияНаСервере = Неопределено
		Или СертификатыДляПодписанияНаСервере.Сертификаты.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РезультатЗапроса = ИнтерфейсМОТПВызовСервера.ЗапроситьПараметрыАвторизации();
	Если РезультатЗапроса.ПараметрыАвторизации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Организация = Неопределено Тогда
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты[0];
	Иначе
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты.Найти(Организация, "Организация");
	КонецЕсли;
	
	Если СтрокаСертификата <> Неопределено Тогда
		СертификатыДляПодписанияНаСервере.МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СтрокаСертификата.Пароль;
		РезультатПодписания = ИнтеграцияМОТП.Подписать(
			РезультатЗапроса.ПараметрыАвторизации.Данные,
			СтрокаСертификата.СертификатКриптографии,
			СертификатыДляПодписанияНаСервере.МенеджерКриптографии);
	КонецЕсли;
	
	Если СтрокаСертификата = Неопределено
		Или Не РезультатПодписания.Успех Тогда
		
		Возврат Ложь;
		
	Иначе
	
		СвойстваПодписи = Новый Структура("Подпись", РезультатПодписания.Подпись);
		
		ПараметрыЗапросаПоОрганизации = Новый Структура;
		ПараметрыЗапросаПоОрганизации.Вставить("Организация",          СтрокаСертификата.Организация);
		ПараметрыЗапросаПоОрганизации.Вставить("ПараметрыАвторизации", РезультатЗапроса.ПараметрыАвторизации);
		ПараметрыЗапросаПоОрганизации.Вставить("СвойстваПодписи",      СвойстваПодписи);
		
		РезультатЗапросаКлючаСессии = ИнтерфейсМОТПВызовСервера.ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
		Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
			
			ИнтерфейсМОТПСлужебный.УстановитьКлючСессии(
				ПараметрыЗапросаПоОрганизации.Организация,
				РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура УстановитьКлючСессии(Организация, ПараметрыКлючаСессии) Экспорт
	
	Попытка
		ДанныеКлючаСессииМОТП = ПараметрыСеанса["ДанныеКлючаСессииМОТП"].Получить();
	Исключение
		ДанныеКлючаСессииМОТП = Неопределено;
	КонецПопытки;
	
	Если ДанныеКлючаСессииМОТП = Неопределено Тогда
		ДанныеКлючаСессииМОТП = Новый Соответствие;
	КонецЕсли;
	
	ДанныеКлючаСессииМОТП.Вставить(Организация, ПараметрыКлючаСессии);
	
	ПараметрыСеанса["ДанныеКлючаСессииМОТП"] = Новый ХранилищеЗначения(ДанныеКлючаСессииМОТП);
	
КонецПроцедуры

// Возвращает ключ сессии для обмена с МОТП.
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - Организация.
// 	СрокДейтвия - Дата, Неопределено           - Срок действия ключа сессии.
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
Функция ПроверитьОбновитьКлючСессии(Знач Организация = Неопределено, Знач СрокДействия = Неопределено) Экспорт
	
	КлючСессии = ИнтерфейсМОТПВызовСервера.ТекущийКлючСессии(Организация, СрокДействия);
	
	ТребуетсяОбновлениеКлючаСессии = (КлючСессии = Неопределено);
	
	Если ТребуетсяОбновлениеКлючаСессии 
		И ИнтерфейсМОТПСлужебный.ОбновитьКлючСессииНаСервере() Тогда
		КлючСессии = ИнтерфейсМОТПВызовСервера.ТекущийКлючСессии();
	КонецЕсли;
	
	Возврат КлючСессии;
	
КонецФункции

// Возвращает структуру данных запроса авторизации
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры авторизации:
// * Идентификатор - Строка - Идентификатор запроса
// * Данные        - Строка - Данные для подписания
Функция ПараметрыАвторизации() Экспорт
	
	ПараметрыАвторизации = Новый Структура;
	ПараметрыАвторизации.Вставить("Идентификатор");
	ПараметрыАвторизации.Вставить("Данные");

	Возврат ПараметрыАвторизации;

КонецФункции

// Возвращает структуру данных кода маркировки.
// 
// Возвращаемое значение:
// 	Структура - Параметры статуса кода маркировки:
// * Статус       - ПеречислениеСсылка.СтатусыКодовМаркировкиМОТП - Статус кода маркировки.
// * ИННВладельца - Строка                                        - ИНН владельца кода маркировки.
Функция ПараметрыСтатусаКодаМаркировки() Экспорт
	
	СтатусКодаМаркировки = Новый Структура;
	СтатусКодаМаркировки.Вставить("Статус");
	СтатусКодаМаркировки.Вставить("ИННВладельца");
	
	Возврат СтатусКодаМаркировки;
	
КонецФункции

// Возвращает структуру данных ключа сессии обмена с МОТП.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры ключа сессии:
// * КлючСессии  - Строка - Ключ сессии.
// * ДействуетДо - Дата   - Дата и время окончания действия ключа сессии.
Функция ПараметрыКлючаСессии() Экспорт
	
	ПараметрыКлючаСессии = Новый Структура;
	ПараметрыКлючаСессии.Вставить("КлючСессии",  "");
	ПараметрыКлючаСессии.Вставить("ДействуетДо", '00010101');
	
	Возврат ПараметрыКлючаСессии;
	
КонецФункции

// Преобразовывает текстовое представление статуса кода маркировки МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыКодовМаркировкиМОТП - статус кода маркировки.
//
Функция СтатусКодаМаркировки(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "EMITTED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Эмитирован;
	ИначеЕсли ЗначениеПоиска = "APPLIED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Нанесен;
	ИначеЕсли ЗначениеПоиска = "INTRODUCED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВведенВОборот;
	ИначеЕсли ЗначениеПоиска = "WRITTEN_OFF" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Списан;
	ИначеЕсли ЗначениеПоиска = "WITHDRAWN" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Продан;
	ИначеЕсли ЗначениеПоиска = "INTRODUCED_RETURNED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВведенВОборотВозвращен;
	ИначеЕсли ЗначениеПоиска = "UNDEFINED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Неопределен;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус кода маркировки: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление статуса участника МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыУчастниковМОТП - статус участника.
//
Функция СтатусУчастника(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "ЗАРЕГИСТРИРОВАН" Тогда
		Возврат Перечисления.СтатусыУчастниковМОТП.Зарегистрирован;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус участника: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление типа операции движения кода маркировки МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыОперацийДвиженияКодовМаркировкиМОТП - тип операции движения кода маркировки.
//
Функция ТипОперацииДвиженияКодаМаркировки(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "APPLICATION" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.Производство;
	ИначеЕсли ЗначениеПоиска = "OWNER_CHANGE" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.СменаВладельца;
	ИначеЕсли ЗначениеПоиска = "AGGREGATION" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.Агрегация;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный тип операции движения кода маркировки: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление типа документа ИС МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыДокументовМОТП - тип документа.
//
Функция ТипДокумента(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "UNIVERSAL_TRANSFER_DOCUMENT" Тогда
		Возврат Перечисления.ТипыДокументовМОТП.УПД;
	ИначеЕсли ЗначениеПоиска = "AGGREGATION_DOCUMENT" Тогда
		Возврат Перечисления.ТипыДокументовМОТП.УведомлениеОбАгрегации;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный тип документа: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление статуса документа ИС МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыДокументовМОТП - статус документа МОТП.
//
Функция СтатусДокумента(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "CHECKED_OK" Тогда
		Возврат Перечисления.СтатусыДокументовМОТП.Проверен;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус документа: %1'"),
			ЗначениеПоиска);
	
КонецФункции

#Область JWT

Функция РасшифроватьТокенJWT(Токен) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("РезультатРасшифровки", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки", "");
	
	ЭлементыТокена = СтрРазделить(Токен, ".");
	Если ЭлементыТокена.Count() <> 3 Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Токен не соответствует формату JWT'");
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ЭлементТокенаДанные = ЭлементыТокена[1];
	
	Данные = ТекстJSONВОбъект(
		ПолучитьСтрокуИзДвоичныхДанных(
			ДвоичныеДанныеЭлементаТокенаJWT(ЭлементТокенаДанные)));
	
	Возврат Данные;
	
КонецФункции

Функция ДвоичныеДанныеЭлементаТокенаJWT(Знач Значение)
	
	Значение = СтрЗаменить(Значение, "-", "+");
	Значение = СтрЗаменить(Значение, "_", "/");
	
	Остаток = СтрДлина(Значение) % 4;
	
	Если Остаток = 1 Тогда
		Возврат Неопределено;
	ИначеЕсли Остаток = 2 Тогда
		Значение = Значение + "==";
	ИначеЕсли Остаток = 3 Тогда
		Значение = Значение + "=";
	КонецЕсли;
	
	Возврат Base64Значение(Значение);
	
КонецФункции

#КонецОбласти

#КонецОбласти
