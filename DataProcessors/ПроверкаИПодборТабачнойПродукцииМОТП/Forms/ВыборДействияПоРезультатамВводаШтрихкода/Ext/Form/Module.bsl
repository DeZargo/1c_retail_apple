﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОтложитьПродукцию.Видимость = Ложь;
	
	ДобавитьОтсканированнуюУпаковку  = 2;
	
	ОбработатьИПроверитьПереданныеПараметры();
	СформироватьЗаголовокФормы();
	СформироватьИнформациюОРезультатахПоиска();
	СформироватьПредложенияДействий();
	
	ИнтеграцияИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(ВладелецФормы);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(ОповещениеПриЗавершении, ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоУпаковкаБезУпаковки" Тогда
	
		Если ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ИзменитьКонтекстПроверки();
			
		ИначеЕсли РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
			
			ПереместитьУпаковкуВДругуюУпаковку(Неопределено);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеУпаковку.Видимость = Ложь;
			Элементы.ГруппаОтложитьУпаковку.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьУпаковку.Видимость         = Ложь;
				Элементы.ОтменаОтложитьУпаковку.Заголовок   = НСтр("ru = 'Закрыть'");
			Иначе
				Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьУпаковку.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоПродукцияНайденаВнеУпаковки" Тогда
		
		Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены")
			Или ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ПереместитьВПачкиБезБлока(Истина);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеПродукцию.Видимость = Ложь;
			Элементы.ГруппаОтложитьПродукцию.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьПродукцию.Видимость         = Ложь;
				Элементы.ОтменаОтложитьПродукцию.Заголовок   = НСтр("ru = 'Закрыть'");
			Иначе
				Элементы.ОтменаОтложитьПродукцию.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьПродукцию.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОтветыНаВопросы

&НаКлиенте
Процедура ДобавитьОтсканированнуюУпаковкуПриИзменении(Элемент)
	
	Если ДобавитьОтсканированнуюУпаковку = 0 Тогда
		
		СтруктураДействия = Новый Структура;
		СтруктураДействия.Вставить("ВидДействия", "ДобавитьНовуюУпаковку");
		СтруктураДействия.Вставить("Штрихкод", ЗначениеШтрихкода);
		
		Закрыть(СтруктураДействия);
		
	Иначе
		
		Элементы.ГруппаОтветНаВопросДобавитьУпаковку.ТолькоПросмотр = Истина;
		Элементы.ГруппаНеДобавлятьОтсканированнуюУпаковку.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьУпаковку(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ОтложитьНайденноеВДругоеМесте");
	СтруктураДействия.Вставить("ЗначениеШтрихкода", ЗначениеШтрихкода);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВПачкиБезБлока(ИзменятьКонтекстПроверки)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",              "ПереместитьВПачкиБезБлока");
	СтруктураДействия.Вставить("Штрихкод",                 ЗначениеШтрихкода);
	СтруктураДействия.Вставить("ИзменятьКонтекстПроверки", ИзменятьКонтекстПроверки);
	
	Закрыть(СтруктураДействия)
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьНовуюВПачкиБезБлока(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",          "ПоместитьНовуюВПачкиБезБлока");
	СтруктураДействия.Вставить("Штрихкод",             ЗначениеШтрихкода);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Оборудование

#КонецОбласти

#Область НастройкаОтображения

#Область ТабачнаяПродукция

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость               = Ложь;
	Элементы.ГруппаОтсканированнаяПродукцияНеПроверена.Видимость = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковкуПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.ДекорацияОтсканированнаяПродукцияНеПроверена.Заголовок  = 
		НСтр("ru = 'Вы повторно отсканировали продукцию, необходимо осканировать упаковку, в которой она найдена.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость    = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок  = 
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодМаркировкиВместоПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код маркировки, а надо отсканировать упаковку, в которой обнаружена продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияПродукции.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена табачная продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПереместитьВПачкиБезБлока()
	
	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость               = Ложь;
	Элементы.ГруппаПереместитьВПачкиБезБлока.Видимость                         = Истина;
	Элементы.ПереместитьВПачкиБезБлока.КнопкаПоУмолчанию                       = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьПродукцию(Форма)
	
	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеПродукцию.Видимость               = Ложь;
	
	Элементы.ГруппаОтложитьПродукцию.Видимость    = Истина;
	Элементы.ОтложитьПродукцию.КнопкаПоУмолчанию  = Истина;
	Элементы.ДекорацияОтложитьПродукцию.Заголовок = ТекстОтложите(Форма);

КонецПроцедуры

#КонецОбласти

#Область Упаковки

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость                      = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость                       = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость  = Ложь;
	Элементы.ГруппаОтсканированнаяУпаковкаНеПроверена.Видимость         = Истина;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьУпаковку(Форма)

	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость                     = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость                      = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость = Ложь;
	Элементы.ГруппаОтложитьУпаковку.Видимость                          = Истина;
	Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию                        = Истина;
	Элементы.ДекорацияОтложитьУпаковку.Заголовок                       = ТекстОтложите(Форма);

КонецПроцедуры 

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковку()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость = Ложь;
	Элементы.ГруппаПовторноОтсканировали.Видимость                     = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость    = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковки.Заголовок  = 
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковки.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена упаковка.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодМаркировкиВместоУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код маркировки, а надо отсканировать упаковку, в которой обнаружена упаковка.'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПриОтветеНаВопросы

#КонецОбласти

#Область ДействияПриЗакрытии

&НаКлиенте
Процедура ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)

	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьУпаковкуВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойУпаковки", ЗначениеШтрихкода);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",   ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить("СтатусПроверки",
	                            ?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
	                              СтатусПроверки,
	                              ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);

КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПачкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)

	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьПачкуВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойПачки", ЗначениеШтрихкода);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",   ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить("СтатусПроверки",
	                            ?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
	                              СтатусПроверки,
	                              ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);

КонецПроцедуры 

&НаКлиенте
Процедура ИзменитьКонтекстПроверки()
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ИзменитьКонтекстПроверки");
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПоискаПоШтрихкоду

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт

	ПараметрыСканирования = ШтрихкодированиеИСКлиентСервер.ИнициализироватьПараметрыСканирования(ВладелецФормы);
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки      = Ложь;
	ПараметрыСканирования.АдресСоответствияАкцизныхМарок = Неопределено;
	ПараметрыСканирования.ЗапрашиватьНоменклатуру        = РежимПодбораСуществующихУпаковок;
	
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект),
	                                                   ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если Не ОжидаетсяСканированиеУпаковки Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОжидаетсяСканированиеУпаковки Тогда
	
		ШтрихкодОтсканированнойУпаковки = ДанныеШтрихкода.Штрихкод;
		ЭтоУпаковкаДокумента   = УпаковкиДокумента.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
		ЭтоДобавленнаяУпаковка = ДобавленныеУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
		МожноИзменитьКонтекст  = ДоступныеДляПроверкиУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
	
	КонецЕсли;
	
	Если ТипУпаковкиНайденного = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		
		Если ОжидаетсяСканированиеУпаковки Тогда
		
			ПоискПоШтрихкодуЗавершениеДляПродукции(ЭтоУпаковкаДокумента,
			                                                  ЭтоДобавленнаяУпаковка,
			                                                  ШтрихкодОтсканированнойУпаковки,
			                                                  МожноИзменитьКонтекст,
			                                                  ДанныеШтрихкода);
			
		КонецЕсли;
	
	Иначе
		
		Если ОжидаетсяСканированиеУпаковки Тогда
			
			ПоискПоШтрихкодуЗавершениеДляУпаковки(ЭтоУпаковкаДокумента,
			                                      ЭтоДобавленнаяУпаковка,
			                                      ШтрихкодОтсканированнойУпаковки,
			                                      МожноИзменитьКонтекст,
			                                      ДанныеШтрихкода);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершениеДляПродукции(ЭтоУпаковкаДокумента,
	                                                        ЭтоДобавленнаяУпаковка,
	                                                        ШтрихкодОтсканированнойУпаковки,
	                                                        МожноИзменитьКонтекст,
	                                                        ДанныеШтрихкода)

	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
			
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции();
				
			КонецЕсли;
			
		ИначеЕсли  ШтрихкодОтсканированнойУпаковки = ЗначениеШтрихкода Тогда
			
			ПоказатьПовторноОтсканировалиУпаковкуПродукции();
			
		Иначе
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьПачкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияПродукции();
					
				КонецЕсли;
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоДобавленнаяУпаковка Тогда
				
				ПереместитьПачкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоУпаковкаДокумента Тогда
				
				ПоказатьПереместитьВПачкиБезБлока();
				
			Иначе
				
				ПоказатьОтложитьПродукцию(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеШтрихкода.Свойство("ТипШтрихкода") Тогда
			
			Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
				
				ПоказатьОтсканировалиКодМаркировкиВместоПродукции();
				
			ИначеЕсли  ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
				
				ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиПродукции();
				
			Иначе
				
				ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена();
				
			КонецЕсли;
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкаПродукцииНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершениеДляУпаковки(ЭтоУпаковкаДокумента,
	                                            ЭтоДобавленнаяУпаковка, 
	                                            ШтрихкодОтсканированнойУпаковки,
	                                            МожноИзменитьКонтекст,
	                                            ДанныеШтрихкода);
	
	Если Не ОжидаетсяСканированиеУпаковки Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
				
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
				
			КонецЕсли;
			
		ИначеЕсли ШтрихкодОтсканированнойУпаковки = ЗначениеШтрихкода Тогда
			
			ПоказатьПовторноОтсканировалиУпаковку();
			
		ИначеЕсли ЭтоДобавленнаяУпаковка Тогда
			
			Если НеСодержитсяВДанныхДокумента Тогда
				
				ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
			
			Иначе
				
				Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьОтложитьУпаковку(ЭтотОбъект);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ЭтоУпаковкаДокумента Тогда
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
					
				КонецЕсли;
				
			Иначе
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеШтрихкода.Свойство("ТипШтрихкода") Тогда
			
			Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
				
				ПоказатьОтсканировалиКодМаркировкиВместоУпаковки();
				
			ИначеЕсли  ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
				
				ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки();
				
			Иначе
				
				ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
				
			КонецЕсли;
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОтложите(Форма)
	
	Если Форма.СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'Упаковка'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'Пачка'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = '%1 уже отложена и помечена стикером № ""%2"".'"), 
			              ТекстУпаковка, 
			              Формат(Форма.СледующийСтикерОтложено - 1, "ЧДЦ=; ЧГ=0"));
		
	Иначе
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'упаковку'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'пачку'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Пометьте найденную %1 стикером № ""%2"" и отложите в сторону.'"), 
			                       ТекстУпаковка, 
			                       Формат(Форма.СледующийСтикерОтложено, "ЧДЦ=; ЧГ=0"));
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры()
	
	ЗначениеШтрихкода = Параметры.ЗначениеШтрихкода;
	ШтрихкодНайден     = Параметры.ШтрихкодНайден;
	
	ЭтоШтрихкодПродукции                 = Параметры.ЭтоШтрихкодПродукции;
	УпаковкаНеСодержитсяВДанныхДокумента = Параметры.УпаковкаНеСодержитсяВДанныхДокумента;
	РежимПроверки                        = Параметры.РежимПроверки;
	СтатусПроверки                       = Параметры.СтатусПроверки;

	ШтрихкодУпаковкиГдеДолжноБыть        = Параметры.ШтрихкодУпаковкиГдеДолжноБыть;
	НеСодержитсяВДанныхДокумента         = Параметры.НеСодержитсяВДанныхДокумента;
	
	ТипУпаковкиГдеДолжноНаходиться       = Параметры.ТипУпаковкиГдеДолжноНаходиться;
	ТипУпаковкиГдеНашли                  = Параметры.ТипУпаковкиГдеНашли;
	ТипУпаковкиНайденного                = Параметры.ТипУпаковкиНайденного;
	
	НомерСтикераОтложено                 = Параметры.НомерСтикераОтложено;
	СледующийСтикерОтложено              = Параметры.СледующийСтикерОтложено;
	
	ДобавленныеУпаковки                  = Параметры.ДобавленныеУпаковки;
	УпаковкиДокумента                    = Параметры.УпаковкиДокумента;
	ДоступныеДляПроверкиУпаковки         = Параметры.ДоступныеДляПроверкиУпаковки;
	
	РежимПодбораСуществующихУпаковок     = Параметры.РежимПодбораСуществующихУпаковок;
	ОбработкаДанныхТСД                   = Параметры.ОбработкаДанныхТСД;
	
КонецПроцедуры 

&НаСервере
Процедура СформироватьПредложенияДействий()
	
	Если Не ШтрихкодНайден Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНеНайдено;
		
		Если ЭтоШтрихкодПродукции Тогда

			Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиМаркировкуНетНеизвестных;
			Элементы.ПереместитьВПачкиБезБлокаНеНайдено.КнопкаПоУмолчанию = Истина;
			Элементы.ГруппаПереместитьВПачкиБезБлокаНеНайдено.Видимость   = Истина;
			
		Иначе
			
			УстановитьДействиеОтсканировалиНеизвестнуюУпаковку();
			
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНайдено;
		
		Если ТипУпаковкиНайденного = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьПродукцию(ЭтотОбъект);
				
			Иначе
				
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоПродукция;
			
		Иначе
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			Иначе
			
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоУпаковка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеОтсканировалиНеизвестнуюУпаковку()

	Если РежимПодбораСуществующихУпаковок Тогда
		ТекстВопроса  = НСтр("ru = 'Добавить новую пустую упаковку?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Упаковка не найдена в данных документа. Добавить в список проверяемого?'");
	КонецЕсли;
	
	Элементы.ДекорацияНеНайденоОтсканировалиУпаковку.Заголовок = ТекстВопроса;
	Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиУпаковку;

КонецПроцедуры 

&НаСервере
Процедура СформироватьИнформациюОРезультатахПоиска()

	ПредставлениеШтрихкода = ИнтеграцияИСКлиентСервер.ПредставлениеШтрихкода(ЗначениеШтрихкода);
	
	СтрокаШтрихкод = Новый ФорматированнаяСтрока(ПредставлениеШтрихкода, Новый Шрифт(,,Истина));
	
	Если ШтрихкодНайден Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиНайденного)  Тогда
			
			Префикс = НСтр("ru = 'Упаковка со штрихкодом'");
			
		Иначе
			
			Префикс = НСтр("ru = 'Продукция с кодом маркировки'");
			
			
		КонецЕсли;
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеДолжноНаходиться) Тогда
			
			Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеНашли) Тогда 
			
				Постфикс = НСтр("ru = 'найдена, но должна находиться в другой упаковке.'");
				
			Иначе
				
				Постфикс = НСтр("ru = 'найдена, но должна находиться в упаковке.'");
				
			КонецЕсли;
			
		Иначе
			
			Постфикс = НСтр("ru = 'найдена, но не должна находиться в упаковке.'");
			
		КонецЕсли;
		
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(Префикс, " """, СтрокаШтрихкод,
		                                                        """ ", Постфикс);
		
	Иначе
		
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(НСтр("ru = 'Код маркировки'"), " """, СтрокаШтрихкод,
		                                                        """ ", НСтр("ru = 'в данных документа не найден.'"));
		
	КонецЕсли;
	
	Элементы.ДекорацияИнформацияОРезультатахПоиска.Заголовок = ТекстШтрихкодНеНайден;

КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы()
	
	Если ШтрихкодНайден Тогда
		
		Заголовок = НСтр("ru = 'Код маркировки найден'");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Код маркировки не найден'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
