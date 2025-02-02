﻿
#Область ПрограммныйИнтерфейс

// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ПО ДЕНЕЖНЫМ СРЕДСТВАМ.

// Процедура формирования движений по регистру "Денежные средства (наличные)".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьДенежныеСредстваНаличные(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДенежныеСредства = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваНаличные;
	
	Если Отказ ИЛИ ТаблицаДенежныеСредства.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ДвиженияДенежныеСредства = Движения.ДенежныеСредстваНаличные;
	ДвиженияДенежныеСредства.Записывать = Истина;
	ДвиженияДенежныеСредства.Загрузить(ТаблицаДенежныеСредства);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Денежные средства к поступлению (наличные)".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьДенежныеСредстваКПоступлениюНаличные(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДенежныеСредства = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваКПоступлениюНаличные;
	
	Если Отказ ИЛИ ТаблицаДенежныеСредства.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ДвиженияДенежныеСредства = Движения.ДенежныеСредстваКПоступлениюНаличные;
	ДвиженияДенежныеСредства.Записывать = Истина;
	ДвиженияДенежныеСредства.Загрузить(ТаблицаДенежныеСредства);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Выплаченная зарплата".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьВыплаченнаяЗарплата(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаВыплаченнаяЗарплата = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВыплаченнаяЗарплата;
	
	Если Отказ ИЛИ ТаблицаВыплаченнаяЗарплата.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ВыплаченнаяЗарплата = Движения.ВыплаченнаяЗарплата;
	ВыплаченнаяЗарплата.Записывать = Истина;
	ВыплаченнаяЗарплата.Загрузить(ТаблицаВыплаченнаяЗарплата);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Денежные средства в кассах ККМ".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДенежныеСредства = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваККМ;
	
	Если Отказ ИЛИ ТаблицаДенежныеСредства.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ДвиженияДенежныеСредства = Движения.ДенежныеСредстваККМ;
	ДвиженияДенежныеСредства.Записывать = Истина;
	ДвиженияДенежныеСредства.Загрузить(ТаблицаДенежныеСредства);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Расчеты с поставщиками".
Процедура ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыСПоставщиками;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.РасчетыСПоставщиками.Записывать = Истина;
	Движения.РасчетыСПоставщиками.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Расчеты с клиентами".
Процедура ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыСКлиентами;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.РасчетыСКлиентами.Записывать = Истина;
	Движения.РасчетыСКлиентами.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Денежные средства к выплате".
Процедура ОтразитьДенежныеСредстваКВыплате(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваКВыплате;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ДенежныеСредстваКВыплате.Записывать = Истина;
	Движения.ДенежныеСредстваКВыплате.Загрузить(Таблица);
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////////////////////

// Функция определяет реквизиты выбранной кассы.
//
// Параметры:
//  Касса - СправочникСсылка.Кассы - Ссылка на кассу.
//
// Возвращаемое значение:
//	Структура - Организация и Валюта выбранной кассы.
//
Функция ПолучитьРеквизитыКассы(Касса) Экспорт

	Возврат Справочники.Кассы.РеквизитыКассы(Касса);
КонецФункции

// Процедура проверяет кассу получателя, указанную в документе.
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от продолжения работы.
//
Процедура ПроверитьКассуПолучателя(ДокументОбъект, Отказ) Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию);
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка);
	
	Если Массив.Найти(ДокументОбъект.ХозяйственнаяОперация) <> Неопределено
		И ЗначениеЗаполнено(ДокументОбъект.КассаПолучатель)
		И ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
		
		РеквизитыКассы = Справочники.Кассы.РеквизитыКассы(ДокументОбъект.КассаПолучатель);
		Если ДокументОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу
			И ЗначениеЗаполнено(ДокументОбъект.Касса) Тогда
			
			Если ДокументОбъект.Касса = ДокументОбъект.КассаПолучатель Тогда
				Текст = НСтр("ru = 'Касса получатель равна кассе документа'");
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ДокументОбъект,
					"КассаПолучатель",
					,
					Отказ);
			
			ИначеЕсли ДокументОбъект.Организация <> РеквизитыКассы.Организация Тогда
				Текст = НСтр("ru = 'Организация кассы получателя не соответствует организации документа'");
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ДокументОбъект,
					"КассаПолучатель",
					,
					Отказ);
				
			КонецЕсли;
		ИначеЕсли ДокументОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию Тогда
			Если ДокументОбъект.Организация = РеквизитыКассы.Организация Тогда
				Текст = НСтр("ru = 'Организация кассы получателя соответствует организации документа'");
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ДокументОбъект,
					"КассаПолучатель",
					,
					Отказ);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет кассу ККМ, указанную в документе.
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	ПроверятьМагазин - Булево
//	Отказ - Булево - Признак отказа от продолжения работы.
//
Процедура ПроверитьКассуККМ(ДокументОбъект, ПроверятьМагазин, Отказ) Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ);
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	Массив.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	
	Если Массив.Найти(ДокументОбъект.ХозяйственнаяОперация) <> Неопределено
		И ЗначениеЗаполнено(ДокументОбъект.КассаККМ)
		И ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
		
		РеквизитыКассыККМ = Справочники.КассыККМ.РеквизитыКассыККМ(ДокументОбъект.КассаККМ);
		Если ДокументОбъект.Организация <> РеквизитыКассыККМ.Организация Тогда
			Текст = НСтр("ru = 'Организация кассы ККМ не соответствует организации документа'");
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ДокументОбъект,
				"КассаККМ",
				,
				Отказ);
			
		КонецЕсли;
		
		Если ПроверятьМагазин 
			И ДокументОбъект.Касса.Магазин <> РеквизитыКассыККМ.Магазин Тогда
			Текст = НСтр("ru = 'Магазин кассы ККМ не соответствует магазину кассы'");
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ДокументОбъект,
				"КассаККМ",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура формирования движений по регистру "Расчеты по эквайрингу".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьПродажиПоПлатежнымКартам(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаРасчетыПоЭквайрингу = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыПоЭквайрингу;
	
	Если Отказ ИЛИ ТаблицаРасчетыПоЭквайрингу.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ДвиженияДенежныеСредства = Движения.ПродажиПоПлатежнымКартам;
	ДвиженияДенежныеСредства.Записывать = Истина;
	ДвиженияДенежныеСредства.Загрузить(ТаблицаРасчетыПоЭквайрингу);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Денежные средства (наличные)".
//
// Параметры:
//	ДокументОбъект - Текущий документ.
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДенежныеСредства = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДенежныеСредстваВКассахККМ;
	
	Если Отказ ИЛИ ТаблицаДенежныеСредства.Количество() = 0 Тогда
	
		Возврат;
		
	КонецЕсли;
	
	ДвиженияДенежныеСредства = Движения.ДенежныеСредстваККМ;
	ДвиженияДенежныеСредства.Записывать = Истина;
	ДвиженияДенежныеСредства.Загрузить(ТаблицаДенежныеСредства);
	
КонецПроцедуры

// Процедура устанавливает параметры выбора для кассы.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий объект.
//	ЭлементКасса - ПолеФормы - Поле для ввода кассы.
//	ОрганизацияИзНастроекПользователя - Булево - Значение Истина, если организация в документе установлена из настроек
//	                                             пользователя, в этом случае связь параметра выбора для реквизита Касса
//	                                             не нужно устанавливать.
//                                               Пользователь должен иметь возможность выбора кассы от любой
//                                               организации.
//
Процедура УстановитьПараметрыВыбораКассы(Объект, ЭлементКасса, ОрганизацияИзНастроекПользователя = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(Объект.Организация)
		И (ОрганизацияИзНастроекПользователя = Ложь ИЛИ ЗначениеЗаполнено(Объект.ДокументОснование)) Тогда
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Организация"));
		ЭлементКасса.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет кассу, банковский счет или эквайринговый терминал в зависимости от формы оплаты документа.
//
// Параметры:
//	ФормаОплаты - ПеречислениеСсылка.ФормыОплаты - Фактическая форма оплаты заявки.
//	ДанныеЗаполнения - Структура - Данные для заполнения документа.
//
Процедура ЗаполнитьРеквизитыДокументаПоФормеОплаты(ДанныеЗаполнения, ФормаОплаты = Неопределено, ЭтоВозврат = Ложь) Экспорт
	
	Если ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
		Касса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяКасса", "");
		Если Не ЗначениеЗаполнено(Касса) Тогда
			Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(
				ДанныеЗаполнения.Организация,
				ФормаОплаты,
				ДанныеЗаполнения.Касса,
				ДанныеЗаполнения.Магазин,
				Пользователи.ТекущийПользователь());
				
			Если ЗначениеЗаполнено(Касса) И Касса.Владелец <> ДанныеЗаполнения.Организация Тогда
				Касса = Справочники.Кассы.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Касса) Тогда
			ДанныеЗаполнения.Вставить("Касса", Касса);
		КонецЕсли;
		
	ИначеЕсли ФормаОплаты = Перечисления.ФормыОплаты.Безналичная Тогда
		БанковскийСчет = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущийБанковскийСчет", "");
		
		Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
			БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
				ДанныеЗаполнения.Организация,
				ФормаОплаты,
				ДанныеЗаполнения.БанковскийСчет);
				
		КонецЕсли;
		
		Если ЗначениеЗаполнено(БанковскийСчет) Тогда
			ДанныеЗаполнения.Вставить("БанковскийСчет", БанковскийСчет);
		КонецЕсли;
		
	ИначеЕсли ФормаОплаты = Неопределено Тогда
		ЭквайринговыйТерминал = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущийЭквайринговыйТерминал", "");
		Если Не ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
			ЭквайринговыйТерминал = Справочники.ЭквайринговыеТерминалы.ЭквайринговыйТерминалПоУмолчанию(
				Неопределено, // Касса
				ДанныеЗаполнения.Организация,
				ДанныеЗаполнения.Магазин);
				
		КонецЕсли;
		ДанныеЗаполнения.Вставить("ВидОплаты", Справочники.ВидыОплатЧекаККМ.ПустаяСсылка());
		ДанныеЗаполнения.Вставить("ПроцентКомиссии", 0.00);
		
		Если ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
			Реквизиты = Справочники.ЭквайринговыеТерминалы.РеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал);
			ДанныеЗаполнения.Вставить("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
			ДанныеЗаполнения.Вставить("Касса", Реквизиты.Касса);
			
			СтруктураПоУмолчанию = Справочники.ЭквайринговыеТерминалы.ВидОплатыПоУмолчанию(ЭквайринговыйТерминал);
			Если ЗначениеЗаполнено(СтруктураПоУмолчанию.ВидОплаты) Тогда
				ДанныеЗаполнения.Вставить("ВидОплаты", СтруктураПоУмолчанию.ВидОплаты);
				ДанныеЗаполнения.Вставить("ПроцентКомиссии", ЭквайрингВызовСервера.ПолучитьПроцентКомиссииДляПлатежнойКарты(ДанныеЗаполнения.ЭквайринговыйТерминал, СтруктураПоУмолчанию.ВидОплаты, ЭтоВозврат));
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает параметры выбора для эквайрингового терминала.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий объект.
//	ЭлементЭквайринговыйТерминал - ПолеФормы - Поле для ввода эквайрингового терминала.
//
Процедура УстановитьПараметрыВыбораЭквайринговогоТерминала(Объект, ЭлементЭквайринговыйТерминал) Экспорт
	Перем УстановитьОграничениеСвязиПараметровВыбора;
	
	УстановитьОграничениеСвязиПараметровВыбора = Ложь;
	Если НЕ ЗначениеЗаполнено(Объект.ЭквайринговыйТерминал) Тогда
		УстановитьОграничениеСвязиПараметровВыбора = Истина;
	КонецЕсли;
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Магазин", "Объект.Магазин"));
	Если УстановитьОграничениеСвязиПараметровВыбора И ЗначениеЗаполнено(Объект.Организация) Тогда
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Организация", "Объект.Организация"));
	КонецЕсли;
	ЭлементЭквайринговыйТерминал.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

// Функция формирует текст строки "В том числе НДС" платежа.
//
// Параметры:
// Возвращаемое значение:
//	СуммаДокумента - Число - Общая сумма документа.
//	МассивДокументов - Массив - Массив документов для определения суммы НДС.
//	ДобавлятьТекстВТомЧисле - Булево - Добавлять строку "В т.ч." в текст платежа.
//	Дата - Дата - Дата, ля расчета ставки НДС.
//
// Возвращаемое значение:
//	Строка - Текст суммы НДС платежа.
//
Функция ТекстСуммаНДСПлатежа(СуммаДокумента, МассивДокументов, ДобавлятьТекстВТомЧисле, НДССАванса = 0, Дата) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИсходнаяТаблица.Документ КАК Документ
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ТаблицаДокументов КАК ИсходнаяТаблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(Товары.Сумма) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.СтавкаНДС КАК СтавкаНДС,
	|		Товары.Сумма + ВЫБОР
	|			КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|				ТОГДА 0
	|			ИНАЧЕ Товары.СуммаНДС
	|		КОНЕЦ КАК Сумма
	|	ИЗ
	|		Документ.ЗаказПоставщику.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|			ПО Товары.Ссылка = ТаблицаДокументов.Документ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.СтавкаНДС,
	|		Товары.Сумма + ВЫБОР
	|			КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|				ТОГДА 0
	|			ИНАЧЕ Товары.СуммаНДС
	|		КОНЕЦ
	|	ИЗ
	|		Документ.ВозвратТоваровПоставщику.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|			ПО Товары.Ссылка = ТаблицаДокументов.Документ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.СтавкаНДС,
	|		Товары.Сумма + ВЫБОР
	|			КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|				ТОГДА 0
	|			ИНАЧЕ Товары.СуммаНДС
	|		КОНЕЦ
	|	ИЗ
	|		Документ.РеализацияТоваров.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|			ПО Товары.Ссылка = ТаблицаДокументов.Документ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.СтавкаНДС,
	|		Товары.Сумма + ВЫБОР
	|			КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|				ТОГДА 0
	|			ИНАЧЕ Товары.СуммаНДС
	|		КОНЕЦ
	|	ИЗ
	|		Документ.ПоступлениеТоваров.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|			ПО Товары.Ссылка = ТаблицаДокументов.Документ
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Товары.СтавкаНДС,
	|		Товары.Сумма + ВЫБОР
	|			КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|				ТОГДА 0
	|			ИНАЧЕ Товары.СуммаНДС
	|		КОНЕЦ
	|	ИЗ
	|		Документ.ЗаказПокупателя.Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|			ПО Товары.Ссылка = ТаблицаДокументов.Документ) КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтавкаНДС
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ");
	ТаблицаДокументов = Новый ТаблицаЗначений;
	ТаблицаДокументов.Колонки.Добавить("Документ", Документы.ТипВсеСсылки());
	Для Сч = 1 По МассивДокументов.Количество() Цикл
		ТаблицаДокументов.Добавить();
	КонецЦикла;
	ТаблицаДокументов.ЗагрузитьКолонку(МассивДокументов, "Документ");
	Запрос.УстановитьПараметр("ТаблицаДокументов", ТаблицаДокументов);
	
	ТаблицаНДС = Новый ТаблицаЗначений;
	ТаблицаНДС.Колонки.Добавить("СтавкаНДС");
	ТаблицаНДС.Колонки.Добавить("Сумма");
	ТаблицаНДС.Колонки.Добавить("СуммаНДС");
	
	СуммаВсего = 0;
	СуммаКРаспределению = СуммаДокумента;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ОбщийИтог Тогда
			СуммаВсего = Выборка.Сумма;
		Иначе
			СтавкаНДСЧисло = ОбработкаТабличнойЧастиТоварыКлиентСерверПовтИсп.ПолучитьСтавкуНДСЧислом(Выборка.СтавкаНДС) * 100;
			
			Если СтавкаНДСЧисло <> 0 Тогда
				НоваяСтрока = ТаблицаНДС.Добавить();
				НоваяСтрока.СтавкаНДС = Выборка.СтавкаНДС;
				НоваяСтрока.Сумма = ?(СуммаВсего <> 0, ОКР(СуммаКРаспределению * Выборка.Сумма / СуммаВсего, 2, 1), 0);
				НоваяСтрока.СуммаНДС = НоваяСтрока.Сумма * СтавкаНДСЧисло / (100 + СтавкаНДСЧисло);
				СуммаКРаспределению = СуммаКРаспределению - НоваяСтрока.Сумма;
			Иначе
				СуммаКРаспределению = СуммаКРаспределению - ?(СуммаВсего <> 0, ОКР(СуммаКРаспределению * Выборка.Сумма / СуммаВсего, 2, 1), 0);
			КонецЕсли;
				
			СуммаВсего = СуммаВсего - Выборка.Сумма;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстНазначениеПлатежаНДС = "";
	Если ТаблицаНДС.Количество() > 0 Тогда
		
		Для Каждого СтрокаТаблицы Из ТаблицаНДС Цикл
			ТекстНазначениеПлатежаНДС = ТекстНазначениеПлатежаНДС
				+ ?(ПустаяСтрока(ТекстНазначениеПлатежаНДС), "", ", ")
				+ НСтр("ru = 'НДС'") + "(" + СтрокаТаблицы.СтавкаНДС + ") "
				+ Формат(СтрокаТаблицы.СуммаНДС, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=");
		КонецЦикла;
			
		Если ДобавлятьТекстВТомЧисле Тогда
			ТекстНазначениеПлатежаНДС = НСтр("ru = 'В т.ч.'") +" "+ ТекстНазначениеПлатежаНДС;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НДССАванса > 0  Тогда
		
		СтавкаНДСАвансаСтрокой = "";
		ДатаДляСтавкиНДС = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
		Если ДатаДляСтавкиНДС >= УчетНДС.ДатаПереходногоПериода() Тогда 
			СтавкаНДСАвансаСтрокой = " (20/120) ";
		Иначе
			СтавкаНДСАвансаСтрокой = " (18/118) ";
		КонецЕсли;
		
		ТекстНазначениеПлатежаНДС = ТекстНазначениеПлатежаНДС
			+ ?(ПустаяСтрока(ТекстНазначениеПлатежаНДС), "", ", ")
			+ НСтр("ru = 'НДС'") + СтавкаНДСАвансаСтрокой
			+ Формат(НДССАванса, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекстНазначениеПлатежаНДС) Тогда
		ТекстНазначениеПлатежаНДС = НСтр("ru = 'Без налога (НДС)'");
	КонецЕсли; 
	
	Возврат ТекстНазначениеПлатежаНДС;
	
КонецФункции

// Возвращает признак расчетов с контрагентами.
//
Функция ЕстьРасчетыСКонтрагентами(ХозяйственнаяОперация = Неопределено) Экспорт
	
	Если ХозяйственнаяОперация = Неопределено Тогда 
		Возврат Ложь;
	Иначе
		Возврат ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВознаграждениеОтКомитента
	КонецЕсли;
	
КонецФункции

// Функция получает менеджер временных таблиц с кор. счетами оплаты.
//
// Параметры:
//  СсылкаДокумента  - <ДокументСсылка> - Пустая ссылка типа документа для печати которого необходимо получить кор.
//                                        счета.
//  МассивОбъектов  - <Массив> - Массив ссылок на документы печати.
//
// Возвращаемое значение:
//   МенеджерВременныхТаблиц - Менеджер таблиц с кор. счетами.
// 
Функция ПолучитьМенеджерТаблицыКорСчетов(СсылкаДокумента, МассивОбъектов) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	ВЫБОР	КОГДА Документ.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗаработнойПлатыРаботнику)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗаработнойПлатыПоВедомостям)
	|			КОГДА Документ.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
	|			ИНАЧЕ Документ.ХозяйственнаяОперация
	|	КОНЕЦ           КАК ХозяйственнаяОперация
	|ПОМЕСТИТЬ ДокументаКорСчета
	|ИЗ
	|	Документ.[ДокументКорСчетов] КАК Документ
	|ГДЕ
	|	Документ.Ссылка В (&МассивОбъектов)
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументаКорСчета.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ЕСТЬNULL(СтатьиДвиженияДенежныхСредств.КорреспондирующийСчет, СтатьиДвиженияДенежныхСредствПредопределенный.КорреспондирующийСчет), """") КАК КорреспондирующийСчет
	|ПОМЕСТИТЬ КорСчета
	|ИЗ
	|	ДокументаКорСчета КАК ДокументаКорСчета
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.[ДокументКорСчетов].РасшифровкаПлатежа КАК ДокументРасшифровкаПлатежа
	|ПО
	|	ДокументРасшифровкаПлатежа.Ссылка = ДокументаКорСчета.Ссылка
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
	|ПО
	|	СтатьиДвиженияДенежныхСредств.Ссылка = ДокументРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|	И СтатьиДвиженияДенежныхСредств.Предопределенный = ЛОЖЬ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредствПредопределенный
	|ПО
	|	СтатьиДвиженияДенежныхСредствПредопределенный.ХозяйственнаяОперация = ДокументаКорСчета.ХозяйственнаяОперация
	|	И СтатьиДвиженияДенежныхСредствПредопределенный.Предопределенный = ИСТИНА
	|ГДЕ
	|	ДокументРасшифровкаПлатежа.Ссылка В (&МассивОбъектов)
	|	ИЛИ ДокументаКорСчета.Ссылка В (&МассивОбъектов)
	|";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ДокументКорСчетов]", СсылкаДокумента.Метаданные().Имя);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Выполнить();
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Заполняет систему налогообложения в документе
//
// Параметры:
//  Документ - ДанныеФормыСтруктура, ДокументОбъект - объект, в котором необходимо заполнить Систему налогообложения
//
Процедура ЗаполнитьСистемуНалогообложения(Документ) Экспорт
	
	СистемаНалогообложения = Неопределено;
	
	Если Документ.РасшифровкаПлатежа.Количество() > 0 Тогда
		
		ДокументРасчетовСКонтрагентом = Документ.РасшифровкаПлатежа[0].ДокументРасчетовСКонтрагентом;
		
		Если ЗначениеЗаполнено(ДокументРасчетовСКонтрагентом) Тогда
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументРасчетовСКонтрагентом, "СистемаНалогообложения") Тогда
				
				СистемаНалогообложения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетовСКонтрагентом, "СистемаНалогообложения");
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СистемаНалогообложения) Тогда
				
				Если ТипЗнч(Документ.Ссылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
					
					Если ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РеализацияТоваров")
						ИЛИ ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
						
						РеквизитыДокументаРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументРасчетовСКонтрагентом, "Склад, Магазин");
						СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
							Документ.Дата, Документ.Организация, РеквизитыДокументаРасчетов.Магазин, РеквизитыДокументаРасчетов.Склад);
						
					ИначеЕсли ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ЧекККМ") Тогда
						
						СтруктураРеквизитов = Новый Структура();
						СтруктураРеквизитов.Вставить("Склад", 	"Магазин.СкладПродажи");
						СтруктураРеквизитов.Вставить("Магазин", "Магазин");
						
						СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
							Документ.Дата, Документ.Организация, РеквизитыДокументаРасчетов.Магазин, РеквизитыДокументаРасчетов.Склад);
						
					КонецЕсли;
					
				ИначеЕсли ТипЗнч(Документ.Ссылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
					
					Если ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ПоступлениеТоваров")
						ИЛИ ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
						
						РеквизитыДокументаРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументРасчетовСКонтрагентом, "Склад, Магазин");
						СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
							Документ.Дата, Документ.Организация, РеквизитыДокументаРасчетов.Магазин, РеквизитыДокументаРасчетов.Склад);
						
					КонецЕсли;
					
				ИначеЕсли ТипЗнч(Документ.Ссылка) = Тип("ДокументСсылка.РегистрацияБезналичнойОплаты") Тогда
					
					РеквизитыДокументаРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументРасчетовСКонтрагентом, "Склад, Магазин");
						
					СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
						Документ.Дата, Документ.Организация, РеквизитыДокументаРасчетов.Магазин, РеквизитыДокументаРасчетов.Склад);
						
				ИначеЕсли ТипЗнч(Документ.Ссылка) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда
					
					Если ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.РеализацияТоваров")
						ИЛИ ТипЗнч(ДокументРасчетовСКонтрагентом) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
						
						РеквизитыДокументаРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументРасчетовСКонтрагентом, "Склад, Магазин");
						
						СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
							Документ.Дата, Документ.Организация, РеквизитыДокументаРасчетов.Магазин, РеквизитыДокументаРасчетов.Склад);
					
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СистемаНалогообложения) Тогда
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Документ, "Магазин") Тогда
			Мазазин = Документ.Магазин;
		Иначе
			Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ.КассаККМ, "Магазин");
		КонецЕсли;
		
		СистемаНалогообложения = ПодключаемоеОборудованиеРТ.ПолучитьСистемуНалогообложения(
			Документ.Дата, Документ.Организация, Магазин);
		
	КонецЕсли;
	
	Документ.СистемаНалогообложения = СистемаНалогообложения;
	
КонецПроцедуры

// Возвращает Кассу ККМ найденную по переданным параметрам
//
// Параметры:
//  Организация	 - Справочник.Организации
//  Магазин		 - Справочник.Магазин
//  РабочееМесто - Справочник.РабочееМесто
// 
// Возвращаемое значение:
//  КассаККМ - найденная КассаККМ по переданным параметрам
//
Функция КассаККМ(Организация, Магазин, РабочееМесто) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КассыККМ.Ссылка КАК КассыККМ
		|ИЗ
		|	Справочник.КассыККМ КАК КассыККМ
		|ГДЕ
		|	КассыККМ.Владелец = &Организация
		|	И КассыККМ.Магазин = &Магазин
		|	И КассыККМ.РабочееМесто = &РабочееМесто
		|	И НЕ КассыККМ.ПометкаУдаления
		|	И КассыККМ.ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККТ)";
	
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("Магазин", 		Магазин);
	Запрос.УстановитьПараметр("РабочееМесто", 	РабочееМесто);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КассыККМ;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует запрос по табличной части "Расшифровка платежа".
//
// Параметры:
//	ДокументОбъект - Документ
//
// Возвращаемое значение:
//	Запрос - запрос по табличной части.
//
Функция ЗапросПоТабличнойЧастиРасшифровкаПлатежа(ДокументОбъект)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НомерСтроки КАК НомерСтроки,
	|	ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|	
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки                               КАК НомерСтроки,
	|	ТаблицаДокумента.ДокументРасчетовСКонтрагентом.Организация КАК Организация,
	|	ТаблицаДокумента.ДокументРасчетовСКонтрагентом.Магазин     КАК Магазин,
	|	ТаблицаДокумента.ДокументРасчетовСКонтрагентом.Контрагент  КАК Контрагент
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокумента.НомерСтроки
	|;
	|");
	
	ТаблицаДокумента = ДокументОбъект.РасшифровкаПлатежа.Выгрузить();
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТаблицаДокумента);
	
	Возврат Запрос;
	
КонецФункции

// Процедура проверяет заполнение табличной части "Расшифровка платежа".
//
// Параметры:
//	ДокументОбъект - Документ
//	СуммаДокумента - Число - Общая сумма документа.
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа.
//	Отказ - Булево - Признак отказа от продолжения работы.
//
Процедура ПроверитьЗаполнениеРасшифровкиПлатежа(
	ДокументОбъект,
	СуммаДокумента,
	ХозяйственнаяОперация,
	Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	МассивНепроверяемыхОпераций = Новый Массив;
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюОрганизацию);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствИзКассыККМ);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеДоходы);
	МассивНепроверяемыхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеРасходы);
	
	Если МассивНепроверяемыхОпераций.Найти(ХозяйственнаяОперация) <> Неопределено Тогда
		Возврат;
	КонецЕсли;

	
	МассивОперацийПроверкиОрганизацииДокументаРасчета = Новый Массив;
	МассивОперацийПроверкиОрганизацииДокументаРасчета.Добавить(Перечисления.ХозяйственныеОперации.ОплатаПоставщику);
	МассивОперацийПроверкиОрганизацииДокументаРасчета.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	МассивОперацийПроверкиОрганизацииДокументаРасчета.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	МассивОперацийПроверкиОрганизацииДокументаРасчета.Добавить(Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
	
	// Проверим соответствие сумм документа и табличной части.
	Если ДокументОбъект.РасшифровкаПлатежа.Количество() > 0
		И СуммаДокумента <> ДокументОбъект.РасшифровкаПлатежа.Итог("Сумма") Тогда
	
		Текст = НСтр("ru = 'Сумма по строкам в табличной части должна равняться сумме документа'");
		ОбщегоНазначения.СообщитьПользователю(
			Текст,
			ДокументОбъект,
			"РасшифровкаПлатежа[0].Сумма",
			,
			Отказ);
		
	КонецЕсли;
	
	// Проверим соответствие организации в шапке документа и в табличной части.
	Если МассивОперацийПроверкиОрганизацииДокументаРасчета.Найти(ХозяйственнаяОперация) <> Неопределено Тогда
		
		Запрос = ЗапросПоТабличнойЧастиРасшифровкаПлатежа(ДокументОбъект);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Текст = "";
			Если ЗначениеЗаполнено(Выборка.Организация)
				И Выборка.Организация <> ДокументОбъект.Организация Тогда
				
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Организация в строке %1 списка ""Расшифровка платежа"" не соответствует организации документа %2'"),
					Выборка.НомерСтроки,
					ДокументОбъект.Организация);
					
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.Контрагент)
				И Выборка.Контрагент <> ДокументОбъект.Контрагент Тогда
				
				Текст = Текст + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Контрагент в строке %1 списка ""Расшифровка платежа"" не соответствует контрагенту документа %2'"),
					Выборка.НомерСтроки,
					ДокументОбъект.Контрагент);
					
			КонецЕсли;
			
			Если НЕ ПустаяСтрока(Текст) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ДокументОбъект,
					"РасшифровкаПлатежа[" + (Выборка.НомерСтроки - 1) + "].ДокументРасчетовСКонтрагентом",
					,
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти