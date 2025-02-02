﻿#Область ПрограммныйИнтерфейс

// Проверяет, что включена ф.о "Использовать подключаемое оборудование" и авторизовался пользователь,
// а не внешний пользователь.
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование") И ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.Пользователи");
	
КонецФункции

// Функция выполняет получение параметров кассы ККМ.
//
Функция ПолучитьПараметрыКассыККМ(КассаККМ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.ПодключаемоеОборудование КАК ИдентификаторУстройства,
	|	КассыККМ.Магазин КАК Магазин,
	|	КассыККМ.Владелец КАК Организация,
	|	КассыККМ.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования,
	|	КассыККМ.НастройкаРаспределенияВыручкиПоСекциям,
	|	КассыККМ.ЭлектронныйЧекSMSПередаютсяПрограммой1С,
	|	КассыККМ.ЭлектронныйЧекEmailПередаютсяПрограммой1С
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", КассаККМ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|Магазин,
								|Организация,
								|ИспользоватьБезПодключенияОборудования,
								|РаспределениеВыручкиПоСекциям,
								|ЭлектронныйЧекSMSПередаютсяПрограммой1С,
								|ЭлектронныйЧекEmailПередаютсяПрограммой1С",
								Выборка.ИдентификаторУстройства,
								Выборка.Магазин,
								Выборка.Организация,
								Выборка.ИспользоватьБезПодключенияОборудования,
								ПодключаемоеОборудованиеРТВызовСервера.ПолучитьРаспределениеВыручкиПоСекциям(Выборка.НастройкаРаспределенияВыручкиПоСекциям),
								Выборка.ЭлектронныйЧекSMSПередаютсяПрограммой1С,
								Выборка.ЭлектронныйЧекEmailПередаютсяПрограммой1С
				);
		
	Иначе
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|Магазин,
								|Организация,
								|ИспользоватьБезПодключенияОборудования,
								|РаспределениеВыручкиПоСекциям,
								|ЭлектронныйЧекSMSПередаютсяПрограммой1С,
								|ЭлектронныйЧекEmailПередаютсяПрограммой1С",
								Справочники.ПодключаемоеОборудование.ПустаяСсылка(),
								Справочники.Магазины.ПустаяСсылка(),
								Справочники.Организации.ПустаяСсылка(),
								Истина,
								ПодключаемоеОборудованиеРТВызовСервера.ПолучитьРаспределениеВыручкиПоСекциям(Неопределено),
								Ложь,
								Ложь
				);
		
	КонецЕсли;
	
КонецФункции // ПолучитьПараметрыКассыККМ()

// Функция выполняет получение параметров ЭТ.
//
Функция ПолучитьПараметрыЭТ(ЭквайринговыйТерминал) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭквайринговыеТерминалы.ПодключаемоеОборудование КАК ИдентификаторУстройства,
	|	ЭквайринговыеТерминалы.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭквайринговыйТерминал);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|ИспользоватьБезПодключенияОборудования",
								Выборка.ИдентификаторУстройства,
								Выборка.ИспользоватьБезПодключенияОборудования
				);
		
	Иначе
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|ИспользоватьБезПодключенияОборудования",
								Справочники.ПодключаемоеОборудование.ПустаяСсылка(),
								Истина
				);
		
	КонецЕсли;
	
КонецФункции

// Возвращает кассу организации, если она одна в ИБ.
// Если переданная в качестве параметра касса уже заполнена - возвращает ее.
// Если касса не передана в качестве параметра или передана пустая,
// возвращает единственную в информационной базе кассу. Если касса
// в базе не одна - возвращает пустую ссылку на кассу.
// Возвращает кассу, только если переданная форма оплаты наличная или Неопределено.
//
// Параметры:
// Организация    - СправочникСсылка.Организации - Организация, для которой необходимо получить счет.
// ФормаОплаты    - ПеречислениеСсылка.ФормыОплаты - Форма оплаты, по которой определяется необходимость
// получения кассы.
// Касса - СправочникСсылка.Кассы - Касса, которую нужно заполнить.
// Пользователь - СправочникСсылка.Пользователи
//
// Возвращаемое значение:
// СправочникСсылка.Кассы
//
Функция ПолучитьКассуОрганизацииПоУмолчанию(
	Знач Организация = Неопределено,
	Знач ФормаОплаты = Неопределено,
	Знач Касса = Неопределено,
	Знач Магазин = Неопределено,
	Пользователь = Неопределено) Экспорт
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(
				Организация,
				ФормаОплаты,
				Касса,
				Магазин,
				Пользователь);
	
КонецФункции // ПолучитьКассуОрганизацииПоУмолчанию()

// Возвращает банковский счет организации, если он один в ИБ.
// Если переданный в качестве параметра банковский счет уже заполнен - возвращает его.
// Если банковский счет не передан в качестве параметра или передан пустой,
// возвращает единственный в информационной базе банковский счет. Если банковский счет
// в базе не один - возвращает пустую ссылку на банковский счет.
// Возвращает банковский счет, только если переданная форма оплаты безналичная или Неопределено.
//
// Параметры:
// Организация    - СправочникСсылка.Организации - Организация, для которой необходимо получить счет.
// ФормаОплаты    - ПеречислениеСсылка.ФормыОплаты - Форма оплаты, по которой определяется необходимость
// получения банковского счета.
// БанковскийСчет - СправочникСсылка.БанковскиеСчетаОрганизаций - Банковский счет, который нужно заполнить.
//
// Возвращаемое значение:
// СправочникСсылка.БанковскиеСчетаОрганизаций
//
Функция ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Знач Организация = Неопределено, Знач ФормаОплаты = Неопределено, Знач БанковскийСчет = Неопределено) Экспорт
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, ФормаОплаты, БанковскийСчет);
	
КонецФункции // ПолучитьБанковскийСчетОрганизацииПоУмолчанию()

// Возвращает банковский счет контрагента, если он один в ИБ.
// Если переданный в качестве параметра банковский счет уже заполнен - возвращает его.
// Если банковский счет не передан в качестве параметра или передан пустой,
// возвращает единственный в информационной базе банковский счет. Если банковский счет
// в базе не один - возвращает пустую ссылку на банковский счет.
// Возвращает банковский счет, только если переданная форма оплаты безналичная или Неопределено.
//
// Параметры:
// Контрагент     - СправочникСсылка.Контрагенты - Контрагент, для которой необходимо получить счет.
// БанковскийСчет - СправочникСсылка.БанковскиеСчетаКонтрагентов - Банковский счет, который нужно заполнить.
//
// Возвращаемое значение:
// СправочникСсылка.БанковскиеСчетаКонтрагентов
//
Функция ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Знач Контрагент, Знач БанковскийСчет = Неопределено) Экспорт
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, БанковскийСчет);
	
КонецФункции // ПолучитьБанковскийСчетКонтрагентаПоУмолчанию()

// Получение значения константы.
//
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Возврат ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты(ИмяКонстанты);
	
КонецФункции

// Заполняет пустую кассу по магазину, рабочему месту и настройкам пользователя.
//
Процедура ЗаполнитьКассуККМПоУмолчанию(КассаККМ, Знач Магазин = Неопределено, Знач РабочееМесто = Неопределено, Знач Пользователь = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(КассаККМ) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Магазин = Неопределено Тогда
		Магазин = ПараметрыСеанса.ТекущийМагазин;
	КонецЕсли;
	
	Если РабочееМесто = Неопределено Тогда
		РабочееМесто = ПараметрыСеанса.РабочееМестоКлиента;
	КонецЕсли;
	
	Если Пользователь = Неопределено Тогда
		Пользователь = ОбщегоНазначенияРТ.ПользовательСУчетомИзмененныхПрав();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиПользователей.Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
	|ГДЕ
	|	НастройкиПользователей.Пользователь = &Пользователь
	|	И НастройкиПользователей.Магазин = &Магазин
	|	И НастройкиПользователей.Настройка = &Настройка";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Магазин"     , Магазин);
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяКассаККМ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ОсновнаяКассаККМ = Справочники.КассыККМ.ПустаяСсылка();
	
	Если Выборка.Следующий() Тогда
		ОсновнаяКассаККМ = Выборка.Значение
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КассыККМ.Ссылка,
	|	ВЫБОР
	|		КОГДА КассыККМ.Ссылка = &ОсновнаяКассаККМ
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ЗначениеУпорядочивания
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Магазин = &Магазин
	|	И КассыККМ.РабочееМесто = &РабочееМесто
	|	И КассыККМ.ТипКассы В(&ТипыКассы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗначениеУпорядочивания";
	
	Запрос.УстановитьПараметр("Магазин"         , Магазин);
	Запрос.УстановитьПараметр("РабочееМесто"    , РабочееМесто);
	Запрос.УстановитьПараметр("ОсновнаяКассаККМ", ОсновнаяКассаККМ);
	
	МассивТипыКассы = Новый Массив;
	МассивТипыКассы.Добавить(Перечисления.ТипыКассККМ.АвтономнаяККМ);
	МассивТипыКассы.Добавить(Перечисления.ТипыКассККМ.ФискальныйРегистратор);
	Запрос.УстановитьПараметр("ТипыКассы"       , МассивТипыКассы);
	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ОсновнаяКассаККМ = Выборка.Ссылка
	КонецЕсли;
	
	КассаККМ = ОсновнаяКассаККМ;
	
КонецПроцедуры


#КонецОбласти
