﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Проверка настроенных параметров.
	ШиринаСлипЧека          = Неопределено;
	КоличествоКопийСлипЧека = Неопределено;
	ДанныеМакетаСлипЧека    = Неопределено;

	Параметры.Свойство("ШиринаСлипЧека",          ШиринаСлипЧека);
	Параметры.Свойство("КоличествоКопийСлипЧека", КоличествоКопийСлипЧека);
	Параметры.Свойство("ДанныеМакетаСлипЧека",    ДанныеМакетаСлипЧека);

	Если ШиринаСлипЧека          = Неопределено
	 Или КоличествоКопийСлипЧека = Неопределено
	 Или ДанныеМакетаСлипЧека    = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;
	// Конец: Проверка настроенных параметров.

	Если Результат Тогда
		ПараметрыПодключения.Вставить("ТипТранзакции", "");
		ПараметрыПодключения.Вставить("НомерКарты", "");
		ПараметрыПодключения.Вставить("НомерЧека", "");
		ПараметрыПодключения.Вставить("СсылочныйНомер", "");
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Оплата платежной картой
	Если Команда = "AuthorizeSales" Тогда
		Сумма      = ВходныеПараметры[0];
		НомерКарты = ВходныеПараметры[1];
		Результат = ОплатитьПлатежнойКартой(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                    Сумма, НомерКарты, ВыходныеПараметры);
	// Возврат платежа
	ИначеЕсли Команда = "AuthorizeRefund" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		НомерЧека      = ?(ВходныеПараметры.Количество() > 3, ВходныеПараметры[3], "");
		Результат = ВернутьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                          Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
	// Отмена платежа
	ИначеЕсли Команда = "AuthorizeVoid" Тогда
		Сумма          = ВходныеПараметры[0];
		СсылочныйНомер = ВходныеПараметры[1];
		НомерЧека      = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		Результат = ОтменитьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                           Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
	// Аварийная отмена платежа
	ИначеЕсли Команда = "EmergencyVoid" Тогда
		Сумма          = ВходныеПараметры[0];
		СсылочныйНомер = ВходныеПараметры[1];
		НомерЧека      = ?(ВходныеПараметры.Количество() > 2, ВходныеПараметры[2], "");
		Результат = АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                    Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
	// Сверка итогов по картам
	ИначеЕсли Команда = "Settlement" Тогда
		Результат = ИтогиДняПоКартам(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Преавторизация платежа
	ИначеЕсли Команда = "AuthorizePreSales" Тогда
		Сумма      = ВходныеПараметры[0];
		НомерКарты = ВходныеПараметры[1];
		Результат = ПреавторизоватьПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                            Сумма, НомерКарты, ВыходныеПараметры);
	// Завершение преавторизации платежа.
	ИначеЕсли Команда = "AuthorizeCompletion" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ВходныеПараметры[2];
		НомерЧека      = ВходныеПараметры[3];

		Результат = ЗавершитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                                    Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
	// Отмена преавторизации платежа.
	ИначеЕсли Команда = "AuthorizeVoidPreSales" Тогда
		Сумма          = ВходныеПараметры[0];
		НомерКарты     = ВходныеПараметры[1];
		СсылочныйНомер = ВходныеПараметры[2];
		НомерЧека      = ВходныеПараметры[3];
		Результат = ОтменитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                                                   Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
	// Получение слип-чека последней операции.
	ИначеЕсли Команда = "ПолучитьСтрокиСлипЧека" Тогда
		Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, Неопределено, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Функция возвращает, будет ли печать слип-чеков на терминале.
	ИначеЕсли Команда = "PrintSlipOnTerminal" ИЛИ Команда = "ПечатьКвитанцийНаТерминале" Тогда
		Результат = ПечатьКвитанцийНаТерминале(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет авторизацию (оплату) по карте.
//
Функция ОплатитьПлатежнойКартой(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                Сумма, НомерКарты, ВыходныеПараметры)

	Результат = Истина;

	СсылочныйНомер = "";
	НомерЧека      = "";

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	// Преобразование номера карты в код карты и срок действия.
	КодКарты = "";

	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ОплатитьПлатежнойКартой(КодКарты,
		                                               СуммаВременная,
		                                               СсылочныйНомер,
		                                               НомерЧека);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ'");
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ПОЛЕТЕКСТОТВЕТА);
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
			ВыходныеПараметры[0] = КодОперации;

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	КодКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(КодКарты);
				ВыходныеПараметры.Добавить(СсылочныйНомер);
				ВыходныеПараметры.Добавить(НомерЧека);
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[3].Добавить("СлипЧек");
				ВыходныеПараметры[3].Добавить(СлипЧек);
				ВыходныеПараметры.Добавить("");
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет возврат платежа по карте.
//
Функция ВернутьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                      Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)

	Результат = Истина;
	
	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Вернуть платеж'");
	
	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);
	
	// Преобразование номера карты в код карты и срок действия.
	КодКарты = "";

	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ВернутьПлатежПоПлатежнойКарте(КодКарты,
		                                                     СуммаВременная,
		                                                     СсылочныйНомер,
		                                                     НомерЧека);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = "Отказ";
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	КодКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(КодКарты);
				ВыходныеПараметры.Добавить(СсылочныйНомер);
				ВыходныеПараметры.Добавить(НомерЧека);
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[3].Добавить("СлипЧек");
				ВыходныеПараметры[3].Добавить(СлипЧек);
				ВыходныеПараметры.Добавить("");
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отмену платежа по карте.
//
Функция ОтменитьПлатежПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                      Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры)

	Результат = Истина;

	СсылочныйНомер = Неопределено;
	НомерЧека      = Неопределено;
	НомерКарты 	   = "";

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить платеж'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ОтменитьПлатежПоПлатежнойКарте(НомерКарты,
		                                                       СуммаВременная,
		                                                       СсылочныйНомер);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ'");
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	НомерКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[0].Добавить("СлипЧек");
				ВыходныеПараметры[0].Добавить(СлипЧек);
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет аварийную отмену операции по карте.
//
Функция АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры)

	Результат = Истина;

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);
	
	СуммаВременная = Сумма * 100;
	
	Ответ = ОбъектДрайвера.АварийнаяОтменаОперации("", СуммаВременная * 100, СсылочныйНомер, НомерЧека);
	Если Не Ответ Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет сверку итогов по картам.
//
Функция ИтогиДняПоКартам(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	Ответ     = Неопределено;

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Сверка итогов'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	Ответ = ОбъектДрайвера.ИтогиДняПоКартам();
	Если Не Ответ Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		Результат = Ложь;
	Иначе
		СлипЧек = "";

		ВыходныеПараметры.Добавить(Новый Массив());
		ВыходныеПараметры[0].Добавить("СлипЧек");
		ВыходныеПараметры[0].Добавить(СлипЧек);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет преавторизацию по карте.
// 
Функция ПреавторизоватьПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                        Сумма, НомерКарты, ВыходныеПараметры)

	Результат = Истина;

	СсылочныйНомер = Неопределено;
	НомерЧека      = Неопределено;

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Преавторизовать платеж'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	// Преобразование номера карты в код карты и срок действия.
	КодКарты = "";
	
	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ПреавторизацияПоПлатежнойКарте(КодКарты,
		                                                      СуммаВременная,
		                                                      СсылочныйНомер,
		                                                      НомерЧека);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ'");
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	КодКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(КодКарты);
				ВыходныеПараметры.Добавить(СсылочныйНомер);
				ВыходныеПараметры.Добавить(НомерЧека);
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[3].Добавить("СлипЧек");
				ВыходныеПараметры[3].Добавить(СлипЧек);
				ВыходныеПараметры.Добавить("");
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет завершение преавторизации по карте.
//
Функция ЗавершитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                                Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)

	Результат = Истина;

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Завершить преавторизацию'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	// Преобразование номера карты в код карты и срок действия.
	КодКарты = "";
	
	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ЗавершениеПреавторизацииПоПлатежнойКарте(КодКарты,
		                                                                СуммаВременная,
		                                                                СсылочныйНомер,
		                                                                НомерЧека);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ'");
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	КодКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[0].Добавить("СлипЧек");
				ВыходныеПараметры[0].Добавить(СлипЧек);
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отмену преавторизации по карте.
//
Функция ОтменитьПреавторизациюПоПлатежнойКарте(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                               Сумма, НомерКарты, СсылочныйНомер, НомерЧека, ВыходныеПараметры)

	Результат = Истина;

	ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить преавторизацию'");

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);

	// Преобразование номера карты в код карты и срок действия.
	КодКарты = "";
	
	Если Результат Тогда
		СуммаВременная = Сумма * 100;

		Ответ = ОбъектДрайвера.ОтменитьПреавторизациюПоПлатежнойКарте(КодКарты,
		                                                              СуммаВременная,
		                                                              СсылочныйНомер);
		Если Не Ответ Тогда
			ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отказ'");
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			КодОперации = ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		Иначе
			ПараметрыПодключения.Вставить("НомерКарты", 	КодКарты);
			ПараметрыПодключения.Вставить("НомерЧека", 		НомерЧека);
			ПараметрыПодключения.Вставить("СсылочныйНомер", СсылочныйНомер);

			СлипЧек = Неопределено;
			Результат = ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры.Добавить(Новый Массив());
				ВыходныеПараметры[0].Добавить("СлипЧек");
				ВыходныеПараметры[0].Добавить(СлипЧек);
			Иначе
				АварийнаяОтменаОперации(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                        Сумма, СсылочныйНомер, НомерЧека, ВыходныеПараметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции
        
// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	РезультатТеста = "";

	УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры);
	Результат = ОбъектДрайвера.ТестУстройства(РезультатТеста);

	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(РезультатТеста);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

 // Заполняет массив строками слип-чека для последующей печати на ФР.
//
Функция ПолучитьСтрокиСлипЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, СлипЧек, ВыходныеПараметры)

	Результат = Истина;
	ИмяМакета = "СлипЧекСофтКейс";

	Если ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить'")
	 Или ПараметрыПодключения.ТипТранзакции = НСтр("ru='Вернуть платеж'")
	 Или ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить платеж'")
	 Или ПараметрыПодключения.ТипТранзакции = НСтр("ru='Преавторизовать платеж'")
	 Или ПараметрыПодключения.ТипТранзакции = НСтр("ru='Завершить преавторизацию'")
	 Или ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить преавторизацию'") Тогда
		ОбластьПараметры = Новый Структура();

		// Параметры устанавливаемые пользователем.
		ОбластьПараметры.Вставить("Банк"       , Параметры.ДанныеМакетаСлипЧека[0].Значение);
		ОбластьПараметры.Вставить("Организация", Параметры.ДанныеМакетаСлипЧека[1].Значение);
		ОбластьПараметры.Вставить("Город"      , Параметры.ДанныеМакетаСлипЧека[2].Значение);
		ОбластьПараметры.Вставить("Адрес"      , Параметры.ДанныеМакетаСлипЧека[3].Значение);
		
		// Параметры поставляемые драйвером.
		ОбластьПараметры.Вставить("TID"        	, ОбъектДрайвера.ПОЛЕНОМЕРТЕРМИНАЛА);
		ДатаВремя = Дата("20"+ОбъектДрайвера.ПОЛЕВРЕМЯТРАНЗАКЦИИ);
		ОбластьПараметры.Вставить("Дата"        , Формат(ДатаВремя, "ДФ=dd.MM.yy"));
		ОбластьПараметры.Вставить("Время"       , Формат(ДатаВремя, "ДФ=HH:mm"));
		Если ПараметрыПодключения.ТипТранзакции = НСтр("ru='Оплатить'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ОПЛАТА'"));
		ИначеЕсли ПараметрыПодключения.ТипТранзакции = НСтр("ru='Вернуть платеж'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ВОЗВРАТ'"));
		ИначеЕсли ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить платеж'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ОТМЕНА ОПЛАТЫ'"));
		ИначеЕсли ПараметрыПодключения.ТипТранзакции = НСтр("ru='Преавторизовать платеж'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ПРЕАВТОРИЗАЦИЯ'"));
		ИначеЕсли ПараметрыПодключения.ТипТранзакции = НСтр("ru='Завершить преавторизацию'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ЗАВЕРШЕНИЕ ПРЕАВТОРИЗАЦИИ'"));
		ИначеЕсли ПараметрыПодключения.ТипТранзакции = НСтр("ru='Отменить преавторизацию'") Тогда
			ОбластьПараметры.Вставить("Операция", НСтр("ru='ОТМЕНА ПРЕАВТОРИЗАЦИИ'"));
		КонецЕсли;
		ОбластьПараметры.Вставить("Сумма",
		                          Формат(?(ПустаяСтрока(ОбъектДрайвера.ПОЛЕСУММА), 0, Число(ОбъектДрайвера.ПОЛЕСУММА)),
		                                 "ЧЦ=15; ЧДЦ=2; ЧС=2; ЧРГ=' '; ЧГ=3,0")
		                         + " "
		                         + "руб.");
		ОбластьПараметры.Вставить("НомерКарты",	ПараметрыПодключения.НомерКарты);
		ОбластьПараметры.Вставить("КодRRN",		ПараметрыПодключения.СсылочныйНомер);
		ОбластьПараметры.Вставить("НомерТранзакции", 		ОбъектДрайвера.ПОЛЕНОМЕРТРАНЗАКЦИИ);
		ОбластьПараметры.Вставить("КодАвторизации", 		ОбъектДрайвера.ПОЛЕАВТОРИЗАЦИОННЫЙКОД);
		ОбластьПараметры.Вставить("КодОтвета", 				ОбъектДрайвера.ПОЛЕКОДОТВЕТА);
		ОбластьПараметры.Вставить("ОписаниеОтветаХоста", 	ОбъектДрайвера.ПОЛЕТЕКСТОТВЕТА);
		ОбластьПараметры.Вставить("ТекстПодвала", Параметры.ДанныеМакетаСлипЧека[4].Значение);
		
		Если Сред(ОбъектДрайвера.ПОЛЕПЕМ, 2, 1) = "1" Тогда
			// Признак ввода ПИН
			АвторизацияПИН = Истина;
			
			ОбластьПараметры.Вставить("ИмяДержателяКарты", 	ОбъектДрайвера.ПОЛЕВЛАДЕЛЕЦКАРТЫ);
			ОбластьПараметры.Вставить("Сертификат", 		ОбъектДрайвера.ПОЛЕСЕРТИФИКАТТРАНЗАКЦИИ);
			ОбластьПараметры.Вставить("AID", 				ОбъектДрайвера.ПОЛЕАИД);
			ОбластьПараметры.Вставить("ТипКарты", 			ОбъектДрайвера.ПОЛЕМЕТКАПРИЛОЖЕНИЯ);
			
		Иначе
			// Авторизация без ввода ПИНа
			АвторизацияПИН = Ложь;
			
			Если Лев(ПараметрыПодключения.НомерКарты, 1) = "4" Тогда
				ТипКарты = "Visa";
			ИначеЕсли Лев(ПараметрыПодключения.НомерКарты, 1) = "5"
				ИЛИ Лев(ПараметрыПодключения.НомерКарты, 1) = "6" Тогда
				ТипКарты = "Maestro/Master card";
			Иначе
				ТипКарты = "";
			КонецЕсли;
			ОбластьПараметры.Вставить("ТипКарты", ТипКарты);
			
		КонецЕсли;
		
		СлипЧек = МенеджерОборудованияКлиент.ПолучитьСлипЧек(ИмяМакета, Параметры.ШиринаСлипЧека, ОбластьПараметры, АвторизацияПИН);
		
	ИначеЕсли ПараметрыПодключения.ТипТранзакции <> НСтр("ru='СверкаИтогов'") Тогда
		Результат = Ложь;
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("Неизвестный тип операции: 
		                                   |обработка не поддерживает вид операции (%ТипТранзакции%).
		                                   |Обратитесь к администратору системы");
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1],
		                                               "%ТипТранзакции%",
		                                               ПараметрыПодключения.ТипТранзакции);
	КонецЕсли;

	Если Результат Тогда
		КопииСлипЧека = "";
		Для Индекс = 1 По Параметры.КоличествоКопийСлипЧека Цикл
			КопииСлипЧека = КопииСлипЧека + СлипЧек + ?(Индекс = Параметры.КоличествоКопийСлипЧека,
			                                            "",
			                                            Символы.ПС + Символ(Параметры.КодСимволаЧастичногоОтреза) + Символы.ПС);
		КонецЦикла;
		СлипЧек = КопииСлипЧека;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Установить параметры драйвера.
//
Процедура УстановитьПараметрыДрайвера(ОбъектДрайвера, Параметры)

КонецПроцедуры

// Функция возвращает, будет ли печать слип-чеков на терминале.
//
Функция ПечатьКвитанцийНаТерминале(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	ВыходныеПараметры.Очистить();  
	ВыходныеПараметры.Добавить(Ложь);
	Возврат Результат;
	
КонецФункции

#КонецОбласти
