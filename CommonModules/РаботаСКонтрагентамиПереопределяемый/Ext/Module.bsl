﻿#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентовВДокументах

// Формирование описания расположения счета-фактуры в документе.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа-основания, для которого необходимо получить описание счета-фактуры.
//  Описание - ТаблицаЗначений - Таблица, в которую помещается описание счета-фактуры.
//				Структура колонок указана в функции ШаблонТаблицыОписания модуля ПроверкаКонтрагентов.
Процедура СформироватьОписаниеДокументовСоСчетомФактуройВПодвале(Форма, Описание) Экспорт
	
	ДокументОбъект = Форма.Объект;
	ДокументСсылка = ДокументОбъект.Ссылка;
	
	Если ПроверкаКонтрагентовКлиентСервер.ЭтоДокументСоСчетомФактуройВПодвале(Форма) Тогда
		
		СчетФактура = ПроверкаКонтрагентовКлиентСервер.СчетФактура(Форма);
		
		Если ЗначениеЗаполнено(СчетФактура) Тогда
			
			ПроверкаКонтрагентов.ДополнитьОписание(
				Описание,
				СчетФактура, 
				Форма.Элементы.СчетФактура,
				Неопределено,
				Форма.Элементы.ГруппаСчетФактура);
				
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

// Формирование описания расположения контрагента, находящегося в шапке документа.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа, для которой необходимо получить описание расположения контрагента.
//  Описание - ТаблицаЗначений - Таблица, в которую помещается описание контрагентов.
//				Структура колонок указана в функции ШаблонТаблицыОписания модуля ПроверкаКонтрагентов.
Процедура СформироватьОписаниеДокументовСКонтрагентомВШапке(Форма, Описание) Экспорт
	
	ДокументОбъект = Форма.Объект;
	ДокументСсылка = ДокументОбъект.Ссылка;
	
	// Заполнение данных по контрагенту в шапке.
	Если ПроверкаКонтрагентовКлиентСервер.ЭтоДокументСКонтрагентомВШапке(Форма) Тогда
		Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			Если ТипЗнч(ДокументСсылка.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
				ПроверкаКонтрагентов.ДополнитьОписание(
					Описание, 
					ДокументСсылка, 
					Форма.Элементы.ДокументОснование,
					ДокументОбъект.ДокументОснование.Контрагент,
					Форма.Элементы.ГруппаКонтрагент);
			КонецЕсли;
		Иначе
			ПроверкаКонтрагентов.ДополнитьОписание(
				Описание, 
				ДокументСсылка, 
				Форма.Элементы.Контрагент,
				ДокументОбъект.Контрагент,
				Форма.Элементы.ГруппаКонтрагент);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

// Формирование описания  расположения контрагентов, находящихся в табличной части документа.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа, для которой необходимо получить описание.
//  Описание - ТаблицаЗначений - Таблица с описанием расположения контрагентов в табличной части документа.
//				Структура колонок указана в функции ШаблонТаблицыОписанияТабличныхЧастей модуля ПроверкаКонтрагентов.
Процедура СформироватьОписаниеДокументовСТабличнымиЧастями(Форма, Описание) Экспорт
	
	
КонецПроцедуры

// Формирование описания расположения контрагентов в счете-фактуре.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма счета-фактуры, для которой необходимо получить описание.
//  Описание - ТаблицаЗначений - Таблица, в которую помещается описание контрагентов.
//				Структура колонок указана в функции ШаблонТаблицыОписания модуля ПроверкаКонтрагентов.
Процедура СформироватьОписаниеСчетовФактур(Форма, Описание) Экспорт
	
	ДокументОбъект = Форма.Объект;
	ДокументСсылка = ДокументОбъект.Ссылка;
	
	// Заполнение данных для счета-фактуры.
	Если ПроверкаКонтрагентовКлиентСервер.ЭтоСчетФактура(Форма) Тогда
		
		Ссылка 			= ДокументСсылка;
		ТипДокумента	= ТипЗнч(Ссылка);
		
		Если ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
			Если ТипЗнч(ДокументОбъект.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
				ПроверкаКонтрагентов.ДополнитьОписание(
					Описание, 
					Ссылка, 
					Форма.Элементы.Контрагент,
					ДокументОбъект.Контрагент,
					Форма.Элементы.ГруппаКонтрагент);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив имен реквизитов счета-фактуры, содержащих контрагентов.
//
// Параметры:
//  Тип	 			- Тип - Тип счета-фактуры, для которой необходимо получить описание.
//  ИменаРеквизитов	- Массив - массив имен(строк) реквизитов счета-фактуры, содержащих контрагентов.
Процедура ПолучитьИменаРеквизитовКонтрагентовВСчетеФактуре(Тип, ИменаРеквизитов) Экспорт
	
	ИменаРеквизитов.Добавить("Контрагент");
	
КонецПроцедуры

// Получение даты документа, в котором используется проверка контрагентов.
// 		Проверка контрагентов будет выполняться по состоянию на эту дату. 
//
// Параметры:
//  ДокументОбъект	 - ДокументОбъект - Документ, в котором используется проверка контрагентов.
//  Дата			 - Дата - Результат получения даты документа.
Процедура ОпределитьДатуВДокументе(ДокументОбъект, Дата) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		Дата = НачалоДня(ДокументОбъект.ДатаСоставления);
	Иначе
		Дата = НачалоДня(ДокументОбъект.Дата);
	КонецЕсли;
	
КонецПроцедуры

// Определение даты в счете-фактуре.
//
// Параметры:
//  СчетФактураОбъект	 - ДанныеФормыСтруктура, ДокументОбъект - Счет-фактура, чью дату необходимо получить.
//  Дата				 - Дата - Результат, дата счета-фактуры.
Процедура ОпределитьДатуВСчетеФактуре(СчетФактураОбъект, Дата) Экспорт
	
	
КонецПроцедуры

// Возможность переопределить стандартное заполнение данных о контрагентах в счет-фактурах, созданных на основании документа.
//
// Параметры:
//  СтандартнаяОбработка - Булево - необходимо установить в Ложь, если стандартная обработка переопределяется.
//  ДокументОбъект       - Произвольный - данные содержащие информацию о счет-фактурах.
//  ДанныеКонтрагентов   - ТаблицаЗначений - подготавливаемая таблица с данными о контрагентах.
//  Форма                - УправляемаяФорма, Неопределено - Форма из которой выполняется вызов.
//
Процедура ЗаполнитьДанныеКонтрагентовВСчетеФактуре(СтандартнаяОбработка, ДокументОбъект, ДанныеКонтрагентов, Форма) Экспорт
	
	
	
КонецПроцедуры

// Возможность переопределить стандартное сохранение результатов проверки контрагентов счет-фактур, выписанных на основании
//             документа основания в форме документа основания. 
//
// Параметры:
//  СтандартнаяОбработка - Булево - необходимо установить в Ложь, если стандартная обработка переопределяется.
//  ДанныеКонтрагентов   - ТаблицаЗначений - подготавливаемая таблица с данными о контрагентах.
//  Форма                - УправляемаяФорма, Неопределено - Форма из которой выполняется вызов.
//
Процедура ЗапомнитьРезультатПроверкиКонтрагентовСчетФактурыВДокументе(СтандартнаяОбработка, ДанныеКонтрагентов, Форма) Экспорт
	
	
	
КонецПроцедуры

// Возможность дополнить структуру РеквизитыПроверкиКонтрагентов при создании в форме документа.
//
// Параметры:
//   Форма          - УправляемаяФорма, Неопределено - Форма из которой выполняется вызов.
//   НовыеРеквизиты - Структура - сформированная структура дополнительных реквизитов документа, которая может быть дополнена.
//
Процедура ДополнитьРеквизитыФормыДокумент(Форма, НовыеРеквизиты) Экспорт


КонецПроцедуры

// Возможность переопределить сохраняемые результаты проверки контрагентов в документе.
//
// Параметры:
//  СтандартнаяОбработка - Булево - необходимо установить в Ложь, если стандартная обработка переопределяется.
//  СохраняемоеЗначение  - Соответствие - сохраняемые данные.
//  Форма                - УправляемаяФорма, Неопределено - Форма из которой выполняется вызов.
//
Процедура СохраняемыеРезультатыПроверкиСчетФактурыВДокументе(СтандартнаяОбработка, СохраняемоеЗначение, Форма) Экспорт
	
	
	
КонецПроцедуры

// Отображения результата проверки контрагента в документе.
//
// Параметры:
//  Форма	 				- УправляемаяФорма - Форма документа, для которого выводится результат проверки контрагента.
//		Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура) формы документа.
//		Структуру полей РеквизитыПроверкиКонтрагентов см. процедуре ИнициализироватьРеквизитыФормыДокумент ОМ
//		ПроверкаКонтрагентов.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
Процедура ОтобразитьРезультатПроверкиКонтрагентаВДокументе(Форма, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Прорисовать состояния контрагентов в документе.
//
// Параметры:
//  Форма					 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  СостояниеПроверки		 - Перечисления.СостоянияПроверкиКонтрагентов	 - Указывает, в каком состояние проверка:
//  	завершилась, не завершилась, выполняется или отсутствует доступ к веб-сервису.
//  ДополнительныеПараметры	 - Неопределено, Структура - Параметры, показывающие в каком элементе формы произошло
//  												изменение и это изменение вызвало запуск проверки контрагента. Описание структуры см в
//  												ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания.
//  СтандартнаяОбработка	 - Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//  										процедуре.
//  										Пример см в ПроверкаКонтрагентов.ПрорисоватьСостоянияКонтрагентовВДокументе.
//
Процедура ПрорисоватьСостоянияКонтрагентовВДокументе(Форма, СостояниеПроверки, ДополнительныеПараметры = Неопределено, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Установка условного оформления в форме выбора или списка документов.
//
// Параметры:
//  Список				 	 - ДинамическийСписок - Динамический список формы выбора или списка документов.
//  СтандартнаяОбработка	 - Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                   процедуре.
Процедура УстановитьУсловноеОформлениеСпискаДокументов(Список, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Установка условного оформления в табличной части документа.
//
// Параметры:
//  Форма				 	 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  СтандартнаяОбработка	 - Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                   процедуре.
Процедура УстановитьУсловноеОформлениеТабличнойЧастиДокумента(Форма, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Добавление колонки с результатом проверки контрагента в таблицу формы документа.
//
// Параметры:
//  Форма				 	 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  СтандартнаяОбработка	 - Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                   процедуре.
Процедура ДобавитьКолонкиТаблицыФормыСРезультатамиПроверкиВТабличныеЧасти(Форма, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Добавление строки с данными проверяемого контрагента при проверке контрагентов в документе.
//
// Параметры:
//	СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//		Значение по умолчанию - Истина;
//	Ссылка - ДокументСсылка - ссылка на документ, в котором выполняется проверка контрагентов;
//	ДанныеКонтрагентов - ТаблицаЗначений - содержит данные проверяемых контрагентов.
//		Структуру колонок таблицы см. в функции ШаблонТаблицыДанныеКонтрагента;
//	Контрагент - ОпределяемыйТип.КонтрагентБИП - проверяемый контрагент, ссылка на
//		элемент справочника контрагентов;
//	Дата - Дата - дата, на которую выполняется проверка;
//	Состояние - ПеречислениеСсылка.СостоянияПроверкиКонтрагентов - текущее состояние
//		проверки существования контрагента.
//
Процедура ДобавитьСтрокуВДанныеКонтрагентовВДокументе(
	СтандартнаяОбработка,
	Ссылка,
	ДанныеКонтрагентов,
	Контрагент,
	Дата,
	Состояние = Неопределено) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Выделение контрагента с ошибкой в строке отчета.
//
// Параметры:
//  ТабличныйДокумент	 - ТабличныйДокумент - Табличный документ отчета, в котором выделяется строка с некорректным
//                                           контрагентом.
//  НомерСтроки			 - Число - Номер строки табличного документа, в которой находится некорректный контрагент.
Процедура ВыделитьКонтрагентаСОшибкойВСтрокеОтчета(ТабличныйДокумент, НомерСтроки) Экспорт
	
	Область = ТабличныйДокумент.Область(НомерСтроки, 2, НомерСтроки, ТабличныйДокумент.ШиринаТаблицы);
	Область.ЦветФона = Новый Цвет(251, 212, 212);
	
КонецПроцедуры

// Предназначена для формирования отчета, в котором используется проверка контрагентов, из общего модуля.
//
// Параметры:
//  ПараметрыФормированияОтчета	 - Структура - Параметры, с которыми необходимо сформировать отчет.
//  Отчет						 - ТабличныйДокумент - результат формирования отчета.
Процедура СформироватьОтчет(ПараметрыФормированияОтчета, Отчет = Неопределено) Экспорт
	
	Если ПараметрыФормированияОтчета.Свойство("ЭтоЖурналУчетаСчетовФактур") Тогда
		
		ВременныйАдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Отчеты.ЖурналУчетаСчетовФактур.СформироватьОтчет(ПараметрыФормированияОтчета, ВременныйАдресХранилища);
		Результат = ПолучитьИзВременногоХранилища(ВременныйАдресХранилища);
		
		Отчет = Результат.СформированныйЖурнал;
		
	КонецЕсли;
	
КонецПроцедуры 

// Вывод результата проверки контрагента в поле табличного документа.
//
// Параметры:
//  Форма				 		 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
//  ПолеТабличногоДокумента		 - ПолеФормы - поле, в которое необходимо выводить отчет.
//  РезультатФормированияОтчета	 - ТабличныйДокумент - Документ, предназначенный для вывода в поле формы.
//  СтандартнаяОбработка		 - Булево - Определяет, выполнять ли действие, определенное в данной процедуре или выполнить
//                                    стандартную обработку.
Процедура ВывестиОтчет(Форма, ПолеТабличногоДокумента, РезультатФормированияОтчета, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вывод раздела отчета с проверкой контрагента в поле табличного документа.
//
// Параметры:
//  Форма				 		 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
//  ПолеТабличногоДокумента		 - ПолеФормы - поле, в которое необходимо выводить отчет.
//  НомерРаздела	 			 - Число - Номер раздела отчета.
//  СтандартнаяОбработка		 - Булево - Определяет, выполнять ли действие, определенное в данной процедуре или выполнить
//                                    стандартную обработку.
Процедура ВывестиРазделОтчета(Форма, ПолеТабличногоДокумента, НомерРаздела, СтандартнаяОбработка) Экспорт

	

КонецПроцедуры

// Определяет, нужно ли выводить данную строку в отчете по некорректным контрагентам.
// 	Пример см. в ПроверкаКонтрагентов.ВыводитьСтрокуОтчета.
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета. 
//		Для проверки контрагентов в отчете важно наличие ключа "ДанныеДляПроверкиКонтрагентов".
//		Данный ключ формируется в процедуре ДобавитьПараметрыДляПроверкиКонтрагентов.
//  Контрагент				- СправочникСсылка - Проверяемый контрагент в строке отчета.
//  ИНН						- Строка - ИНН контрагента.
//  КПП						- Строка - ИНН контрагента.
//  Дата					- Дата - Дата, на которую необходимо выполнять проверку контрагента.
//  СтандартнаяОбработка	- Булево - Определяет, выполнять ли действие, определенное в данной процедуре или выполнить
//                                  стандартную обработку.
//  Результат				- Булево - Определяет, нужно ли выводить строку.
Процедура ОпределитьНужноЛиВыводитьСтрокуОтчета(СтруктураПараметров, Контрагент, ИНН, КПП, Дата, Результат, СтандартнаяОбработка) Экспорт
	
	Если СтруктураПараметров.Свойство("ЭтоЖурналУчетаСчетовФактур") Тогда
		
		Если СтруктураПараметров.Свойство("ЭтоИтог") И СтруктураПараметров.ЭтоИтог Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ДанныеДляПроверкиКонтрагентов = СтруктураПараметров.ДанныеДляПроверкиКонтрагентов;
			НедействующиеКонтрагенты = ДанныеДляПроверкиКонтрагентов.НедействующиеКонтрагенты;
			
			Результат = НедействующиеКонтрагенты.НайтиСтроки(Новый Структура("Контрагент", Контрагент)).Количество() > 0;

		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет, нужно ли проверять контрагентов в разделе отчета.
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета. 
//		Для проверки контрагентов в отчете важно наличие ключа "ДанныеДляПроверкиКонтрагентов".
//		Данный ключ формируется в процедуре ДобавитьПараметрыДляПроверкиКонтрагентов.
//  НомерРаздела			- Число - Номер раздела отчета.
//  ДополнительныеПараметры	- Произвольный - Дополнительная информация, связанная с разделом.
//  СтандартнаяОбработка	- Булево - Определяет, выполнять ли действие, определенное в данной процедуре или выполнить
//                                  стандартную обработку.
Процедура ОпределитьНужноЛиПроверятьКонтрагентовВРазделеОтчета(СтруктураПараметров, НомерРаздела, ДополнительныеПараметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Отображения результата проверки контрагента в отчете.
//
// Параметры:
//  Форма	 				- УправляемаяФорма - Форма отчета, для которого выводится результат проверки контрагента.
//		Результат проверки хранится в реквизите РеквизитыПроверкиКонтрагентов(Структура),
//		ПроверкаКонтрагентовНедействующиеКонтрагенты формы отчета.
//		Структуру полей РеквизитыПроверкиКонтрагентов см. процедуре ИнициализироватьРеквизитыФормыОтчета ОМ
//		ПроверкаКонтрагентов.
//  СтандартнаяОбработка	- Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                  процедуре.
Процедура ОтобразитьРезультатПроверкиКонтрагентаВОтчете(Форма, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Установка условного оформления в форме выбора или списка справочника контрагентов.
//
// Параметры:
//  Список				 	 - ДинамическийСписок - Динамический список формы выбора или списка справочника контрагентов.
//  СтандартнаяОбработка	 - Булево - Если Ложь, то игнорируется стандартное действие и выполняется указанное в данной
//                                   процедуре.
Процедура УстановитьУсловноеОформлениеСпискаКонтрагентов(Список, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Важно: заполнение реализации метода обязательно.
// Определяет свойства справочников контрагентов.
// Параметры:
//	СвойстваСправочников - ТаблицаЗначений - в таблице заполняется список
//		справочников контрагентов и их свойства. Колонки таблицы:
//		* Имя - Строка - имя справочника;
//		* Иерархический - Булево - справочник является иерархическим;
//		* РеквизитИНН - Строка- имя реквизита ИНН;
//		* РеквизитКПП - Строка- имя реквизита КПП;
//		* ОтключитьСозданиеИзДосьеКонтрагента - Булево - если Истина,
//			тогда не будет предлагаться создание элемента справочника из
//			отчета "Досье контрагента".
//
Процедура ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников) Экспорт
	
	СвойствоСправочника = СвойстваСправочников.Добавить();
	СвойствоСправочника.Имя           = "Контрагенты";
	СвойствоСправочника.Иерархический = Истина;
	СвойствоСправочника.РеквизитИНН   = "ИНН";
	СвойствоСправочника.РеквизитКПП   = "КПП";
	СвойствоСправочника.ОтключитьСозданиеИзДосьеКонтрагента = Ложь;
	
	СвойствоСправочника = СвойстваСправочников.Добавить();
	СвойствоСправочника.Имя           = "Организации";
	СвойствоСправочника.Иерархический = Ложь;
	СвойствоСправочника.РеквизитИНН   = "ИНН";
	СвойствоСправочника.РеквизитКПП   = "КПП";
	СвойствоСправочника.ОтключитьСозданиеИзДосьеКонтрагента = Ложь;
	
КонецПроцедуры

// Определяет, является ли контрагент физическим или юридическим лицом.
//
// Параметры:
//  СтандартнаяОбработка  - Булево - если стандартный механизм переопределяется, то должно быть установлено значение "Ложь".
//  ЭтоЮрЛицо             - Булево - Истина, если юридическое лицо, и Ложь, если физическое.
//  ДанныеКонтрагента     - Структура - структура, которая содержит данные обрабатываемого контрагента.
//
Процедура ПриОпределенииВидаКонтрагента(СтандартнаяОбработка, ЭтоЮрЛицо, ДанныеКонтрагента) Экспорт
	
	Если ДанныеКонтрагента.ДополнительныеПараметры.Свойство("Контрагент") Тогда
		КонтрагентСсылка = ДанныеКонтрагента.Контрагент;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(КонтрагентСсылка)) И КонтрагентСсылка <> Справочники.Контрагенты.ПустаяСсылка() Тогда
			// Ссылка
			
			ЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрагентСсылка, "ЮрФизЛицо");
			ЭтоЮрЛицо = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
		Иначе
			// Объект
			ЮрФизЛицо = КонтрагентСсылка.ЮрФизЛицо;
			ЭтоЮрЛицо = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
			
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Определяется, является ли контрагент иностранным.
//
// Параметры:
//  ДанныеКонтрагента   - СтрокаТаблицыЗначений - Содержит информацию о контрагенте. 
//      Подробнее о колонках таблицы можно узнать в описании к процедуре ПроверкаКонтрагентов.ШаблонТаблицыДанныеКонтрагента().
//  ЯвляетсяИностранным - Булево - Результат проверки.
Процедура ПриОпределенииКонтрагентЯвляетсяИностранным(ДанныеКонтрагента, ЯвляетсяИностранным) Экспорт
	
	КонтрагентСсылка = ДанныеКонтрагента.Контрагент;
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(КонтрагентСсылка)) И КонтрагентСсылка <> Справочники.Контрагенты.ПустаяСсылка() Тогда
		// Ссылка
		ЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтрагентСсылка, "ЮрФизЛицо");
		ЯвляетсяИностранным = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент;
	Иначе
		// Объект
		ЮрФизЛицо = КонтрагентСсылка.ЮрФизЛицо;
		ЯвляетсяИностранным = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент;
	КонецЕсли;
	
КонецПроцедуры

// Возможность дополнить структуру РеквизитыПроверкиКонтрагентов для формы справочника. 
//
// Параметры:
//  Форма  - УправляемаяФорма - форма, для которой дополняется структура РеквизитыПроверкиКонтрагентов.
//  НовыеРеквизиты  - Структура - структура, которая транслируется в реквизит формы РеквизитыПроверкиКонтрагентов.
//
Процедура ДополнитьРеквизитыФормыКонтрагент(Форма, НовыеРеквизиты) Экспорт
	
	НовыеРеквизиты.Вставить("НеИспользоватьКэш", Ложь);

	Если Форма.ИмяФормы = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
		
		ЮрФизЛицо = Форма.Объект.ЮрФизЛицо;
		НовыеРеквизиты.ЭтоИностранныйКонтрагент  = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент;
		НовыеРеквизиты.ЭтоЮридическоеЛицо        = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо
												   ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент
												   ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ПустаяСсылка();
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеИнформацииДляДосьеКонтрагента

// Определение состава и порядка вывода в отчет "Досье контрагента" данных из информационной базы.
//
// Параметры:
//  ТаблицаОписания - ТаблицаЗначений - описание см. Отчеты.ДосьеКонтрагента.НоваяТаблицаОписаниеДанныхПрограммы.
//
Процедура ЗаполнитьОписаниеДанныхПрограммы(ТаблицаОписания) Экспорт

	
КонецПроцедуры

// Заполнение информации о контрагенте по данным информационной базы для отчета "Досье контрагента".
//
// Параметры:
//  ИнформацияОСвязях  - Структура - описание см. РаботаСКонтрагентами.НоваяИнформацияОСвязяхЮридическогоЛица
//                 и РаботаСКонтрагентами.НоваяИнформацияОСвязяхПредпринимателя.
//                 При заполнении в структуру ИнформацияОСвязях.ДанныеПрограммы добавляются данные о контрагенте.
//                 Ключи структуры должны соответствовать полям ИмяДанных таблицы, заполненной 
//                 в процедуре ЗаполнитьОписаниеДанныхПрограммы.
//  Контрагент  - ОпределяемыйТип.КонтрагентБИП - ссылка на контрагента в информационной базе.
//                 Если при вызове процедуры ссылка пустая, необходимо найти контрагента до данным,
//                 содержащимся в структуре ИнформацияОСвязях.
//
Процедура ДополнитьИнформациюДаннымиПрограммы(ИнформацияОСвязях, Контрагент) Экспорт
	
	
КонецПроцедуры 

// Заполнение наименований видов деятельности по ОКВЭД для вывода в отчет "Досье контрагента".
//
// Параметры:
//  ВидыДеятельности  - ТаблицаЗначений - см. РаботаСКонтрагентами.НоваяТаблицаВидыДеятельности.
//                 В процедуре необходимо заполнить в строках таблицы поле НаименованиеОКВЭД,
//                 соответствующее заполненному полю КодОКВЭД.
//                 Если в строке поле ЭтоОКВЭД2 - Истина - наименование заполняется из редакции 2 классификатора ОКВЭД.
//                 Если в строке поле ЭтоОКВЭД2 - Ложь - наименование заполняется из редакции 1 классификатора ОКВЭД.
//
Процедура ЗаполнитьНаименованияВидовДеятельностиКонтрагента(ВидыДеятельности) Экспорт
	
КонецПроцедуры

// Заполнение идентификатора конфигурации для статистики переходов по ссылкам сервиса 1С:Контрагент.
//
// Параметры:
//  ИдентификаторКонфигурации  - Строка - идентификатор. 
//                 Рекомендуется использовать латинские строчные буквы и цифры.
//
Процедура ЗаполнитьИдентификаторКонфигурации(ИдентификаторКонфигурации) Экспорт


КонецПроцедуры

#КонецОбласти 

#Область ПрочиеПроцедуры

// Определение цветов выделения результатов проверки контрагентов.
// 		Для примера см. функцию ЦветаРезультатовПроверки ОМ ПроверкаКонтрагентовКлиентСервер.
//
// Параметры:
//  Цвета	 - Структура - Имена ключей - это названия цветов, которые необходимо определить.
// 		Список ключей см ПроверкаКонтрагентовВызовСервера.ЦветаРезультатовПроверки().
Процедура ПриОпределенииЦветовРезультатовПроверки(Цвета) Экспорт
	
КонецПроцедуры

// Заполнение значений колонок ЭтоЮридическоеЛицо и ЭтоИностранныйКонтрагент 
//		в таблице с данными контрагента.
//		Заполнять следует запросом и только те строки, в которых значения не заполнены.
//
// Параметры:
//  ДанныеКонтрагентов	 - ТаблицаЗначений - Таблица с данными контрагентов.
//  СтандартнаяОбработка - Булево - Если Истина, то заполнение будет выполнено стандартным 
// 		образом путем перебора каждой строки таблицы.
//
Процедура ДополнитьДанныеКонтрагентов(ДанныеКонтрагентов, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
