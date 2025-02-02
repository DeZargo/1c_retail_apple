﻿
#Область ПрограммныйИнтерфейс

// Функция вызывается для клиентской обработки печати ценников и этикеток.
// 
Функция ОбработкаКомандыПечатиЦенниковИЭтикеток(ПараметрыПечати) Экспорт
	
	МассивДокументов = ПараметрыПечати.ОбъектыПечати;
	МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПолучитьМассивНепроведенныхДокументов(МассивДокументов);
	ПараметрыПечатиЦенниковИЭтикеток = ПараметрыПечати.ДополнительныеПараметры.ПараметрыПечатиЦенниковИЭтикеток;
	УстановитьРежим = ПараметрыПечатиЦенниковИЭтикеток.УстановитьРежим;
	
	Если МассивНепроведенныхДокументов.Количество() > 0 Тогда
		
		Если МассивНепроведенныхДокументов.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Печать %1% возможна только после проведения документа, провести документ?'")
		Иначе
			ТекстВопроса = НСтр("ru = 'Печать %1% возможна только после проведения документов, провести документы?'")
		КонецЕсли;
		
		Если УстановитьРежим = "ПечатьЦенников" Тогда
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1%", НСтр("ru = 'ценников'"));
		ИначеЕсли УстановитьРежим = "ПечатьЭтикеток" Тогда
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1%", НСтр("ru = 'этикеток'"));
		ИначеЕсли УстановитьРежим = "ПечатьЦенниковИЭтикеток" Тогда
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1%", НСтр("ru = 'ценников и этикеток'"));
		Иначе
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1%", "");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("МассивДокументов"                , МассивДокументов);
		ДополнительныеПараметры.Вставить("МассивНепроведенныхДокументов"   , МассивНепроведенныхДокументов);
		ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЦенниковИЭтикеток);
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросОПроведенииДокументовЦенникиИЭтикетки", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОткрытьФормуПечатиЦенниковИЭтикеток(МассивДокументов, 
											МассивНепроведенныхДокументов, 
											ПараметрыПечатиЦенниковИЭтикеток);
	КонецЕсли;
	
	
КонецФункции // ОбработкаКомандыПечатиЦенники()

// Обработка ответа на вопрос о проведении документов.
// Если существует хоть один проведенный документ в массиве, то открывается обработка ПечатьЭтикетокИЦенников.
//
Процедура ОповещениеВопросОПроведенииДокументовЦенникиИЭтикетки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПровестиДокументы(ДополнительныеПараметры.МассивНепроведенныхДокументов);
	Иначе
		МассивНепроведенныхДокументов = ДополнительныеПараметры.МассивНепроведенныхДокументов;
	КонецЕсли;
	
	ОткрытьФормуПечатиЦенниковИЭтикеток(ДополнительныеПараметры.МассивДокументов, 
										МассивНепроведенныхДокументов,
										ДополнительныеПараметры.ПараметрыПечатиЦенниковИЭтикеток);
	
КонецПроцедуры

// Функция вызывается перед формированием печатной формы.
// Установка цен номенклатуры
//
Функция ОбработкаКомандыПечатиУстановкиЦен(ПараметрыПечати) Экспорт
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Документ.УстановкаЦенНоменклатуры.Форма.ВыборЦенНоменклатуры.Открытие");
             
	ПараметрыФормы = Новый Структура("МассивДокументов", ПараметрыПечати.ОбъектыПечати);
	ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаКомандыПечатиЗавершение", ЭтотОбъект, ПараметрыПечати);
	
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ВыборЦенНоменклатуры",
				ПараметрыФормы,
				ПараметрыПечати.Форма,
				Новый УникальныйИдентификатор,
				,
				,
				ОбработчикОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецФункции // ОбработкаКомандыПечатиЦенники()

// Функция вызывается перед формированием печатной формы.
// Переоценка товаров
//
Функция ОбработкаКомандыПечатиПереоценкиТоваров(ПараметрыПечати) Экспорт
	
	ПараметрыФормы = Новый Структура("СсылкиНаДокументы", ПараметрыПечати.ОбъектыПечати);
	ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаКомандыПечатиЗавершение", ЭтотОбъект, ПараметрыПечати);
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "ОбщаяФорма.ФормаВыбораДляПечатиПереоценки.Открытие");
    
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДляПечатиПереоценки",
				ПараметрыФормы,
				ПараметрыПечати.Форма,
				Новый УникальныйИдентификатор,
				,
				,
				ОбработчикОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецФункции // ОбработкаКомандыПечатиЦенники()

// Функция вызывается перед формированием печатной формы.
// Переоценка товаров
//
Функция ОбработкаКомандыПечатиТТН(ПараметрыПечати) Экспорт
	
	ПараметрыФормы = Новый Структура; 
	ПараметрыФормы.Вставить("СсылкиНаДокументы"      , ПараметрыПечати.ОбъектыПечати);
	ПараметрыФормы.Вставить("ПечатьПослеЗакрытия"    , Истина);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ПараметрыПечати.ДополнительныеПараметры);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаКомандыПечатиЗавершение", ЭтотОбъект, ПараметрыПечати);
	
	ОткрытьФорму("Обработка.ПечатьТТН.Форма",
				ПараметрыФормы,
				ПараметрыПечати.Форма,
				Новый УникальныйИдентификатор,
				,
				,
				ОбработчикОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецФункции // ОбработкаКомандыПечатиЦенники()

// Функция вызывается перед формированием печатной формы.
//
Функция ОбработкаКомандыПечатиТТНСправкаРазделБ(ПараметрыПечати) Экспорт
	
	ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыПечати.ДополнительныеПараметры);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ПараметрыПечати.МенеджерПечати, 
													ПараметрыПечати.Идентификатор,
													ПараметрыПечати.ОбъектыПечати,
													ПараметрыПечати.Форма,
													ДополнительныеПараметры);
	
КонецФункции

// Функция вызывается перед формированием печатных форм инкассации.
// Для передачи в процедуру печати таблицу с управляемой формы документа.
//
Функция ОбработкаКомандыПечатиПрепроводительнойВедомостиНакладнойКСумке(ПараметрыПечати) Экспорт
	
	ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыПечати.ДополнительныеПараметры);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ПараметрыПечати.МенеджерПечати, 
													ПараметрыПечати.Идентификатор,
													ПараметрыПечати.ОбъектыПечати,
													ПараметрыПечати.Форма,
													ДополнительныеПараметры
	);
	
КонецФункции

// Функция вызывается перед формированием печатных форм КМ3.
// Корректируется список документов (остаются только возвраты).
//
Функция ОбработкаКомандыПечатиКМ3(ПараметрыПечати) Экспорт
	
	МассивДокументов = УправлениеПечатьюРТВызовСервера.МассивВозвратовЧекККМ(ПараметрыПечати.ОбъектыПечати);
	ПараметрыПечати.ОбъектыПечати = МассивДокументов;
	МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПолучитьМассивНепроведенныхДокументов(МассивДокументов);
	
	Если МассивНепроведенныхДокументов.Количество() > 0 Тогда

		Если МассивНепроведенныхДокументов.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документа, провести документ?'")
		Иначе
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документов, провести документы?'")
		КонецЕсли;

		ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыПечати);
		ДополнительныеПараметры.Вставить("МассивНепроведенныхДокументов", МассивНепроведенныхДокументов);
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросОПроведенииДокументовВозвратаЧекККМ", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		Если ПараметрыПечати.ОбъектыПечати.Количество() = 0 Тогда
			ПараметрыПечати.ОбъектыПечати.Добавить(ПредопределенноеЗначение("Документ.ЧекККМ.ПустаяСсылка"));
		КонецЕсли;
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ПараметрыПечати.МенеджерПечати, 
														ПараметрыПечати.Идентификатор,
														ПараметрыПечати.ОбъектыПечати,
														ПараметрыПечати.Форма,
														ПараметрыПечати.ДополнительныеПараметры);
	КонецЕсли;
	
КонецФункции

// Обработка ответа на вопрос о проведении документов ЧековКММ-возвратов.
//
Процедура ОповещениеВопросОПроведенииДокументовВозвратаЧекККМ(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПровестиДокументы(ДополнительныеПараметры.МассивНепроведенныхДокументов);
		Если МассивНепроведенныхДокументов.Количество() = 0 Тогда
			
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ДополнительныеПараметры.МенеджерПечати, 
															ДополнительныеПараметры.Идентификатор,
															ДополнительныеПараметры.ОбъектыПечати,
															ДополнительныеПараметры.Форма,
															ДополнительныеПараметры.ДополнительныеПараметры);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Функция вызывается для печати товарного чека на ФР.
//
Функция ОбработкаКомандыПечатиТоварногоЧекаДляФР(ПараметрыПечати) Экспорт
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
	Если НЕ ИспользоватьПодключаемоеОборудование Тогда
		ТекстСообщения = НСтр("ru = 'Не используется подключаемое оборудование.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь
	КонецЕсли;
	
	Если МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда // Проверка на определенность рабочего места ВО.
		РабочееМесто = МенеджерОборудованияКлиентПовтИсп.ПолучитьРабочееМестоКлиента();
	Иначе
		ТекстСообщения = НСтр("ru = 'Предварительно необходимо выбрать рабочее место внешнего оборудования текущего сеанса.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь
	КонецЕсли;
	
	ПараметрыПечати.Вставить("ИспользоватьПодключаемоеОборудование", ИспользоватьПодключаемоеОборудование);
	ПараметрыПечати.Вставить("РабочееМесто"                        , РабочееМесто);
	
	//Если ПараметрыПечати.ОбъектыПечати.Количество() > 0 Тогда
	//	
	//	ЭлементМассива = ПараметрыПечати.ОбъектыПечати[0];
	//	Если ТипЗнч(ЭлементМассива) = Тип("Массив") Тогда
	//		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПолучитьМассивНепроведенныхДокументов(ЭлементМассива);
	//	Иначе
			МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПолучитьМассивНепроведенныхДокументов(ПараметрыПечати.ОбъектыПечати);
	//	КонецЕсли;
	//Иначе
	//	МассивНепроведенныхДокументов = Новый Массив;
	//КонецЕсли;
	
	Если МассивНепроведенныхДокументов.Количество() > 0 Тогда
		
		Если МассивНепроведенныхДокументов.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документа, провести документ?'")
		Иначе
			ТекстВопроса = НСтр("ru = 'Печать возможна только после проведения документов, провести документы?'")
		КонецЕсли;
		
		ДополнительныеПараметры = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыПечати);
		ДополнительныеПараметры.Вставить("МассивНепроведенныхДокументов", МассивНепроведенныхДокументов);
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросОПроведенииДокументовТоварныйЧекККМДляФР", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗавершитьПечатьТоварногоЧекаДляФР(ПараметрыПечати)
	КонецЕсли;
	
КонецФункции

// Обработка ответа на вопрос о проведении документов ЧековКММ.
//
Процедура ОповещениеВопросОПроведенииДокументовТоварныйЧекККМДляФР(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		МассивНепроведенныхДокументов = ФормированиеПечатныхФормВызовСервера.ПровестиДокументы(ДополнительныеПараметры.МассивНепроведенныхДокументов);
		Если МассивНепроведенныхДокументов.Количество() = 0 Тогда
			ЗавершитьПечатьТоварногоЧекаДляФР(ДополнительныеПараметры)
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Функция вызывается перед формированием печатной формы
// после завершения открытия формы настроек или дополнительных параметров печати.
//
Функция ОбработкаКомандыПечатиЗавершение(Результат, ПараметрыФормы) Экспорт
	
	Если Результат <> Неопределено Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ПараметрыФормы.МенеджерПечати, 
														ПараметрыФормы.Идентификатор,
														ПараметрыФормы.ОбъектыПечати,
														ПараметрыФормы.Форма,
														Результат);
	КонецЕсли;
	
КонецФункции

// Когда определить склонение представляется возможным только на Клиенте
// вызывается этот обработчик.
Функция ОбработкаКомандыПечатиЗаявленияПриВозврате(ПараметрыПечати) Экспорт
	
	СоответствиеФизЛицВИменительномПадеже = УправлениеПечатьюРТВызовСервера.СоответствиеФизЛицВИменительномПадежеВозвратовТоваров(ПараметрыПечати.ОбъектыПечати);
	
	СтруктураСоответствия = СтруктураСклоненияПоСоответствию(СоответствиеФизЛицВИменительномПадеже);
	
	ПараметрыПечати.ДополнительныеПараметры.Вставить("СоответствиеФизЛиц", СтруктураСоответствия);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ПараметрыПечати.МенеджерПечати, 
													ПараметрыПечати.Идентификатор,
													ПараметрыПечати.ОбъектыПечати,
													ПараметрыПечати.Форма,
													ПараметрыПечати.ДополнительныеПараметры);
	
КонецФункции

// Возвращает сумму выделенных ячеек табличного документа.
// 
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере) Экспорт
	
	Если НеобходимоОбновитьСумму(Результат, КэшВыделеннойОбласти) Тогда
		ПолеСумма = 0;
		КоличествоВыделенныхОбластей = КэшВыделеннойОбласти.Количество();
		Если КоличествоВыделенныхОбластей = 0      // Ничего не выделено
			ИЛИ КэшВыделеннойОбласти.Свойство("T") // Выделен весь табличный документ (Ctrl+A)
			Тогда
			КэшВыделеннойОбласти.Вставить("Сумма", 0);
		ИначеЕсли КоличествоВыделенныхОбластей = 1 Тогда
			// Если выделено небольшое количество ячеек, то получим сумму на клиенте
			Для каждого КлючИЗначение Из КэшВыделеннойОбласти Цикл
				СтруктураАдресВыделеннойОбласти = КлючИЗначение.Значение;
			КонецЦикла;
			
			РазмерОбластиПоВертикали   = СтруктураАдресВыделеннойОбласти.Низ   - СтруктураАдресВыделеннойОбласти.Верх;
			РазмерОбластиПоГоризонтали = СтруктураАдресВыделеннойОбласти.Право - СтруктураАдресВыделеннойОбласти.Лево;
			
			// В некоторых отчетах показатели (да и аналитика на которую может встать пользователь
			// выводятся в "объединенных" ячейках - не желательно в этом случае делать серверный вызов. 
			// Выделенная область из 10 ячеек закрывает все такие случае и скорее всего всегда будет доступна на клиенте.
			// Максимум, может быть сделан один неявный серверный вызов
			ВычислитьНаКлиенте = (РазмерОбластиПоВертикали + РазмерОбластиПоГоризонтали) < 12;
			Если ВычислитьНаКлиенте Тогда
				СуммаВЯчейках = 0;
				Для ИндексСтрока = СтруктураАдресВыделеннойОбласти.Верх По СтруктураАдресВыделеннойОбласти.Низ Цикл
					Для ИндексКолонка = СтруктураАдресВыделеннойОбласти.Лево По СтруктураАдресВыделеннойОбласти.Право Цикл
						Попытка
							Ячейка = Результат.Область(ИндексСтрока, ИндексКолонка, ИндексСтрока, ИндексКолонка);
							Если Ячейка.Видимость = Истина Тогда
								Если Ячейка.СодержитЗначение И ТипЗнч(Ячейка.Значение) = Тип("Число") Тогда
									СуммаВЯчейках = СуммаВЯчейках + Ячейка.Значение;
								ИначеЕсли ЗначениеЗаполнено(Ячейка.Текст) Тогда
									ЧислоВЯчейке  = Вычислить("Число(СтрЗаменить(Ячейка.Текст, Символ(32), Символ(0)))");
									СуммаВЯчейках = СуммаВЯчейках + ЧислоВЯчейке;
								КонецЕсли;
							КонецЕсли;
						Исключение
						КонецПопытки;
					КонецЦикла;
				КонецЦикла;
				
				ПолеСумма = СуммаВЯчейках;
				КэшВыделеннойОбласти.Вставить("Сумма", ПолеСумма);
			Иначе
				// Если ячеек много, то лучше вычислим сумму ячеек на сервере за один вызов,
				// т.к. неявных серверных вызовов может быть гораздо больше
				НеобходимоВычислятьНаСервере = Истина;
			КонецЕсли;
		Иначе
			// Вычислим сумму ячеек на сервере
			НеобходимоВычислятьНаСервере = Истина;
		КонецЕсли;
	Иначе	
		ПолеСумма = КэшВыделеннойОбласти.Сумма;
	КонецЕсли;
	
КонецПроцедуры

// Процедура, вызываемая при открытии формы печати.
// 
Процедура ПриОткрытии(Форма, Отказ) Экспорт
	
	// Установка модифицированности пользовательских настроек 
	// для их автоматического сохранения при закрытии формы
	Если Форма.Отчет.Свойство("РежимРасшифровки") Тогда
		Форма.ПользовательскиеНастройкиМодифицированы = Не Форма.Отчет.РежимРасшифровки;
	Иначе
		Форма.ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура? вызываемая перед закрытием формы печати.
//
Процедура ПередЗакрытием(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Структура отчета задается динамически, поэтому в сохранении Варианта нет необходимости.
	Форма.ВариантМодифицирован = Ложь;
	
	// Взводим модифицированность пользовательских настроек,
	// для того чтобы они сохранились при закрытии отчета
	Форма.ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

// Процедура обрабатывает выбор организации.
//
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций,
	Организация, ВключатьОбособленныеПодразделения) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
			ВключатьОбособленныеПодразделения = Значение.ВключатьОбособленныеПодразделения;
		Иначе
			Организация = Неопределено;
			ВключатьОбособленныеПодразделения = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Процедура обрабатывает открытие организации.
//
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда				
				ПоказатьЗначение(, Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Процедура формирует данные для печати на принтер этикеток и передает их драйверу оборудования.
Процедура ОбработкаКомандыПечатиЦенниковИЭтикетокНаПринтереЭтикеток(ПараметрыПечати) Экспорт
	
	Обработка = ПараметрыПечати.ОбъектыПечати[0];
	
	Если Обработка.Товары.НайтиСтроки(Новый Структура("Выбран", Истина)).Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано ни одного товара'"));
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПечати.Свойство("ИдентификаторФормы") Тогда
		ИдентификаторФормы = ПараметрыПечати.ИдентификаторФормы;
	Иначе
		ИдентификаторФормы = ПараметрыПечати.Форма.УникальныйИдентификатор;
	КонецЕсли;
	
	ДанныеДляПринтераЭтикеток = УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикетокДляПринтераЭтикеток(Обработка, ПараметрыПечати.МенеджерПечати, ПараметрыПечати.ТекущийРазмер);
	
	Если ДанныеДляПринтераЭтикеток.Количество() > 0 Тогда
		
		Для Каждого ТекМакет Из ДанныеДляПринтераЭтикеток Цикл
			
			МенеджерОборудованияКлиент.НачатьПечатьЭтикеток(Неопределено, ИдентификаторФормы, ТекМакет.XML, ТекМакет.Этикетки);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьШтрихкодовУпаковок(ОписаниеКоманды) Экспорт
		
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуПечатиЦенниковИЭтикеток(МассивДокументов, 
											  МассивНепроведенныхДокументов, 
											  ПараметрыПечатиЦенниковИЭтикеток)
	
	Если МассивДокументов.Количество() - МассивНепроведенныхДокументов.Количество() > 0 Тогда
		
		ИмяПроцедурыПодготовкиСтруктурыДанных = ПараметрыПечатиЦенниковИЭтикеток.ИмяПроцедурыПодготовкиСтруктурыДанных;
		
		АдресВХранилище = Вычислить(ИмяПроцедурыПодготовкиСтруктурыДанных + "(МассивДокументов, МассивНепроведенныхДокументов, ПараметрыПечатиЦенниковИЭтикеток)");
		
		СтруктураПараметры = Новый Структура("АдресВХранилище", АдресВХранилище);
		
		ОткрытьФорму(
		"Обработка.ПечатьЭтикетокИЦенников.Форма.Форма",
		СтруктураПараметры,            // Параметры
		,                              // Владелец
		Новый УникальныйИдентификатор  // Уникальность
		);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершитьПечатьТоварногоЧекаДляФР(ПараметрДействия)
	
	СтруктураПараметровПечати = УправлениеПечатьюРТВызовСервера.СтруктураПараметровПечатиТоварногоЧекаДляФР(ПараметрДействия.ОбъектыПечати, ПараметрДействия.РабочееМесто);
	
	Если СтруктураПараметровПечати = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Проверьте настройку кассы ККМ, ширины ленты и подключаемого оборудования.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	СтрокаПечати = УправлениеПечатьюРТВызовСервера.СтрокаПечатиНаФР(ПараметрДействия.ОбъектыПечати, СтруктураПараметровПечати.ШиринаЛенты);
	
	Если ПустаяСтрока(СтрокаПечати) Тогда
		ТекстСообщения = НСтр("ru = 'Данные для печати отсутствуют.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрДействия.Форма.Доступность = Ложь;
	
	ИдентификаторУстройстваФР = СтруктураПараметровПечати.ИдентификаторУстройства;
	                   
	ОповещенияПриЗавершение = Новый ОписаниеОповещения("ЗавершитьПечатьТоварногоЧекаДляФРЗавершение", ЭтотОбъект, ПараметрДействия);
	МенеджерОборудованияКлиент.НачатьПечатьТекста(ОповещенияПриЗавершение, Новый УникальныйИдентификатор, СтрокаПечати, ИдентификаторУстройстваФР);
	
КонецПроцедуры

Процедура ЗавершитьПечатьТоварногоЧекаДляФРЗавершение(РезультатВыполнения, ПараметрДействия) Экспорт
	
	ПараметрДействия.Форма.Доступность = Истина;
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'При печати товарного чека произошла ошибка.
		                            |Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция СтруктураСклоненияПоСоответствию(СоответствиеФизЛицВИменительномПадеже)

	СоответствиеФизЛицВРодительномПадеже  = Новый Соответствие;
	СоответствиеФизЛицВДательномПадеже    = Новый Соответствие;
	СоответствиеФизЛицВТворительномПадеже = Новый Соответствие;
	
	Для каждого ЭлементСоответствия Из СоответствиеФизЛицВИменительномПадеже Цикл
	
		ФИОФизЛицаИП = ЭлементСоответствия.Значение;
		ФИОФизЛицаРП = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 2);
		ФИОФизЛицаДП = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 3);
		ФИОФизЛицаТП = ОбщегоНазначенияРТКлиентСерверПовтИсп.ПолучитьСклонениеФИО(ФИОФизЛицаИП, 5);
		
		СоответствиеФизЛицВРодительномПадеже.Вставить(ЭлементСоответствия.Ключ, ФИОФизЛицаРП);
		СоответствиеФизЛицВДательномПадеже.Вставить(ЭлементСоответствия.Ключ, ФИОФизЛицаДП);
		СоответствиеФизЛицВТворительномПадеже.Вставить(ЭлементСоответствия.Ключ, ФИОФизЛицаТП);
		
	КонецЦикла;
	
	СтруктураСоответствия = Новый Структура();
	СтруктураСоответствия.Вставить("ВИменительномПадеже", СоответствиеФизЛицВИменительномПадеже);
	СтруктураСоответствия.Вставить("ВРодительномПадеже" , СоответствиеФизЛицВРодительномПадеже);
	СтруктураСоответствия.Вставить("ВДательномПадеже"   , СоответствиеФизЛицВДательномПадеже);
	СтруктураСоответствия.Вставить("ВТворительномПадеже", СоответствиеФизЛицВТворительномПадеже);
	
	Возврат СтруктураСоответствия;
КонецФункции

Функция НеобходимоОбновитьСумму(Результат, КэшВыделеннойОбласти)
	Перем СтруктураАдресВыделеннойОбласти;
	
	ВыделенныеОбласти    = Результат.ВыделенныеОбласти;
	КоличествоВыделенных = ВыделенныеОбласти.Количество();
	
	Если КоличествоВыделенных = 0 Тогда
		КэшВыделеннойОбласти = Новый Структура();
		Возврат Истина;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Ложь;
	Если ТипЗнч(КэшВыделеннойОбласти) <> Тип("Структура") Тогда
		КэшВыделеннойОбласти = Новый Структура();
		ВозвращаемоеЗначение = Истина;
	ИначеЕсли ВыделенныеОбласти.Количество() <> КэшВыделеннойОбласти.Количество() Тогда
		КэшВыделеннойОбласти = Новый Структура();
		ВозвращаемоеЗначение = Истина;
	Иначе
		Для ИндексОбласти = 0 По КоличествоВыделенных - 1 Цикл
			ВыделеннаяОбласть = ВыделенныеОбласти[ИндексОбласти];
			ИмяОбласти = СтрЗаменить(ВыделеннаяОбласть.Имя, ":", "_");
			КэшВыделеннойОбласти.Свойство(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			
			// не нашли нужную область в кэше, поэтому переинициализируем кэш
			Если ТипЗнч(СтруктураАдресВыделеннойОбласти) <> Тип("Структура") Тогда
				КэшВыделеннойОбласти = Новый Структура();
				ВозвращаемоеЗначение = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для ИндексОбласти = 0 По КоличествоВыделенных - 1 Цикл
		ВыделеннаяОбласть = ВыделенныеОбласти[ИндексОбласти];
		ИмяОбласти = СтрЗаменить(ВыделеннаяОбласть.Имя, ":", "_");
		
		Если ТипЗнч(ВыделеннаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			СтруктураАдресВыделеннойОбласти = Новый Структура("Верх, Низ, Лево, Право", 0, 0, 0, 0);
			КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			ВозвращаемоеЗначение = Истина;
			Продолжить;
		КонецЕсли;
		
		КэшВыделеннойОбласти.Свойство(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
		Если ТипЗнч(СтруктураАдресВыделеннойОбласти) <> Тип("Структура") Тогда
			СтруктураАдресВыделеннойОбласти = Новый Структура("Верх, Низ, Лево, Право", 0, 0, 0, 0);
			КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
			ВозвращаемоеЗначение = Истина;
		КонецЕсли;
		
		Если СтруктураАдресВыделеннойОбласти.Верх <> ВыделеннаяОбласть.Верх
			ИЛИ СтруктураАдресВыделеннойОбласти.Низ <> ВыделеннаяОбласть.Низ
			ИЛИ СтруктураАдресВыделеннойОбласти.Лево <> ВыделеннаяОбласть.Лево
			ИЛИ СтруктураАдресВыделеннойОбласти.Право <> ВыделеннаяОбласть.Право Тогда
				СтруктураАдресВыделеннойОбласти = Новый Структура("Верх, Низ, Лево, Право",
					ВыделеннаяОбласть.Верх, ВыделеннаяОбласть.Низ, ВыделеннаяОбласть.Лево, ВыделеннаяОбласть.Право);
				КэшВыделеннойОбласти.Вставить(ИмяОбласти, СтруктураАдресВыделеннойОбласти);
				ВозвращаемоеЗначение = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти
