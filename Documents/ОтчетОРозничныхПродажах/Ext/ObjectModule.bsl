﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПеременныеМодуля

Перем мТекстСводныхОтчетов, мЕстьОтличия;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ОтчетОРозничныхПродажахXML(ОтчетОРозничныхПродажах) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	ВозвращаемоеЗначение.Вставить("СообщенияXML", Новый Массив);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажах.Дата КАК Дата,
	|	ОтчетОРозничныхПродажах.Организация КАК Организация,
	|	ОтчетОРозничныхПродажах.Организация.GLN КАК ОрганизацияGLN
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки,
	|	ВЫБОР
	|		КОГДА Товары.КоличествоУпаковок <> 0
	|			ТОГДА ВЫБОР
	|					КОГДА НЕ Товары.Ссылка.ЦенаВключаетНДС
	|						ТОГДА ВЫРАЗИТЬ((Товары.Сумма + Товары.СуммаНДС) / Товары.КоличествоУпаковок КАК Число(15,2))
	|					ИНАЧЕ ВЫРАЗИТЬ(Товары.Сумма / Товары.КоличествоУпаковок КАК Число(15,2))
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Стоимость,
	|	Серии.Серия.НомерКиЗГИСМ КАК НомерКиЗ
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах.Серии КАК Серии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах.Товары КАК Товары
	|		ПО (Товары.Ссылка = Серии.Ссылка)
	|			И (Товары.Номенклатура = Серии.Номенклатура)
	|			И (Товары.Характеристика = Серии.Характеристика)
	|ГДЕ
	|	Серии.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки");
	
	Запрос.УстановитьПараметр("Ссылка", ОтчетОРозничныхПродажах);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка = Результат[0].Выбрать();
	Если Не Шапка.Следующий() Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки'");
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	Организация = Шапка.Организация;
	
	Товары = Результат[1].Выгрузить();
	Если Товары.Количество() = 0 Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки'");
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ИмяТипа   = "query";
	ИмяПакета = "retail_sale";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа);
	
	ОтчетОРозничныхПродажах = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета);
	ОтчетОРозничныхПродажах.action_id  = ОтчетОРозничныхПродажах.action_id;
	ОтчетОРозничныхПродажах.sender_gln = Шапка.ОрганизацияGLN;
	ОтчетОРозничныхПродажах.sales      = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(ОтчетОРозничныхПродажах, "sales");
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(ОтчетОРозничныхПродажах.sales, "detail");
		НоваяСтрока.sign_num  = СтрокаТЧ.НомерКиЗ;
		НоваяСтрока.cost      = СтрокаТЧ.Стоимость;
		НоваяСтрока.sale_time = Шапка.Дата;
		
		ОтчетОРозничныхПродажах.sales.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = ОтчетОРозничныхПродажах;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа);
	
	СообщениеXML = Новый Структура;
	СообщениеXML.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор);
	СообщениеXML.Вставить("Описание", НСтр("ru = 'Отчет о розничных продажах маркированных товаров'"));
	СообщениеXML.Вставить("ТекстСообщенияXML", ТекстСообщенияXML);
	СообщениеXML.Вставить("ТипСообщения", Перечисления.ТипыСообщенийГИСМ.Исходящее);
	СообщениеXML.Вставить("Организация", Организация);
	СообщениеXML.Вставить("Операция", Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	СообщениеXML.Вставить("Документ", ОтчетОРозничныхПродажах);
	СообщениеXML.Вставить("Версия", 0);
	
	ВозвращаемоеЗначение.СообщенияXML.Добавить(СообщениеXML);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		Возврат ОтчетОРозничныхПродажахXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// &ЗамерПроизводительности
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетОРозничныхПродажах.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПродажиСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоПлатежнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	
	Если ДополнительныеСвойства.ИспользуетсяКомиссионнаяТорговля Тогда
		ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитенту(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	БонусныеБаллыСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("ОтчетОРозничныхПродажахПроведение",ВремяНачалаЗамера,Товары.Количество(), "Вес по табличной части ""Товары""");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// В погашении только подарочные сертификаты.
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ВозвращенныеТовары");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	МассивНепроверяемыхРеквизитов.Добавить("ВозвращенныеТовары.Склад");
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, Новый Структура("ИмяТЧ", "ВозвращенныеТовары"));	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.ОтчетОРозничныхПродажах.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	
	ПродажиСервер.ПроверитьЗаполнениеСклада(
		ЭтотОбъект,
		"Товары",
		Отказ
	);
	
	ПродажиСервер.ПроверитьЗаполнениеСклада(
		ЭтотОбъект,
		"ВозвращенныеТовары",
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЦеныСертификатов(
		ЭтотОбъект,
		"Товары",
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЧтоНетПодарочныхСертификатов(
		ЭтотОбъект,
		"ВозвращенныеТовары",
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьТабличнуюЧастьПогашения(
		ЭтотОбъект,
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ
	);
	
	ИспользоватьКомиссионнуюТорговлю = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссионнуюТорговлю");
	
	Если ИспользоватьКомиссионнуюТорговлю Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА Товары.Поставщик = &ПустойПоставщик
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПоставщикПустой,
		|	ВЫБОР
		|		КОГДА Товары.Договор = &ПустойДоговор
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДоговорПустой
		|ПОМЕСТИТЬ ТаблицаВЗапросе
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаВЗапросе.НомерСтроки КАК НомерСтроки,
		|	ТаблицаВЗапросе.ПоставщикПустой КАК ПоставщикПустой,
		|	ТаблицаВЗапросе.ДоговорПустой КАК ДоговорПустой
		|ИЗ
		|	ТаблицаВЗапросе КАК ТаблицаВЗапросе
		|ГДЕ
		|	(ТаблицаВЗапросе.ПоставщикПустой
		|				И НЕ ТаблицаВЗапросе.ДоговорПустой
		|			ИЛИ (НЕ ТаблицаВЗапросе.ПоставщикПустой
		|					И ТаблицаВЗапросе.ДоговорПустой))";
		
		Запрос.УстановитьПараметр("Товары"         , ЭтотОбъект["Товары"].Выгрузить());
		Запрос.УстановитьПараметр("ПустойПоставщик", Справочники.Контрагенты.ПустаяСсылка());
		Запрос.УстановитьПараметр("ПустойДоговор"  , Справочники.ДоговорыПлатежныхАгентов.ПустаяСсылка());
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.ПоставщикПустой Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке N%1 табличной части ""Товары"" выбран договор, но не выбран поставщик'"),
					Выборка.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ЭтотОбъект,
					"Товары[" + (Выборка.НомерСтроки - 1) + "].Поставщик" ,
					,
					Отказ);
			Иначе
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке N%1 табличной части ""Товары"" выбран поставщик, но не выбран договор'"),
					Выборка.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					Текст,
					ЭтотОбъект,
					"Товары[" + (Выборка.НомерСтроки - 1) + "].Договор" ,
					,
					Отказ);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщаяСумма = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	ОплатаПревышенаОднимВидом = Ложь;
	РеквизитПриСмешанномПревышении = "";
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПроверитьНаличиеСсылокВСводномОтчетеПоКассовойСмене();
	
	ВозвратыПоПрочейВыручке = ПрочаяВыручка.Итог("СуммаВозврата");
	СуммаВозвратов     = ВозвращенныеТовары.Итог("Сумма") + ВозвратыПоПрочейВыручке;
	СуммаПрочейВыручки = ПрочаяВыручка.Итог("СуммаПоступления") - ВозвратыПоПрочейВыручке;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ОтчетОРозничныхПродажах.ПараметрыУказанияСерий(ЭтотОбъект));
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Товары.Количество() = 0 Тогда
		СуммаДокумента = СуммаОплатыНаличных + ОплатаПлатежнымиКартами.Итог("Сумма")+ ОплатаНаличнымиАгентскихПлатежей.Итог("Сумма");
	Иначе
		ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
			ЭтотОбъект,
			ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС) 
			+ СуммаПрочейВыручки,
			"СуммаДокумента");
	КонецЕсли;
		
	// ИнтеграцияГИСМ
	ЕстьМаркируемаяПродукцияГИСМ = ИнтеграцияГИСМ_РТ.ЕстьМаркируемаяПродукцияГИСМ(Товары);
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	ПрочаяВыручка.Очистить();
	ИнициализироватьДокумент();
	УчетНДС.СкорректироватьНДСВТЧДокумента(ЭтотОбъект, Товары);
	УчетНДС.СкорректироватьНДСВТЧДокумента(ЭтотОбъект, ВозвращенныеТовары);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
			КассаККМ      = ДанныеЗаполнения.КассаККМ;
			Магазин       = КассаККМ.Магазин;
			Организация   = КассаККМ.Владелец;
		Иначе
			Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
			Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
			КассаККМ      = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(Организация,,КассаККМ,Магазин,);
		КонецЕсли;
	КонецЕсли;
	
	ЦенаВключаетНДС = ОбщегоНазначенияРТ.ПолучитьЗначениеРеквизитаВПривилегированномРежиме(Магазин.ПравилоЦенообразования, "ЦенаВключаетНДС");
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("КассаККМ")
			И НЕ ЗначениеЗаполнено(КассаККМ) Тогда
			Если ЗначениеЗаполнено(Организация) Тогда
				Если ДанныеЗаполнения.КассаККМ.Владелец <> Организация Тогда
					ДанныеЗаполнения.КассаККМ = Справочники.КассыККМ.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассаККМ, "Организация");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура формирует массив имен регистров для контроля проведения.
//
Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	ИспользуетсяКомиссионнаяТорговля = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссионнуюТорговлю");
	ИспользуетсяУчетИмпортныхТоваров = ПолучитьФункциональнуюОпцию("ИспользоватьУчетИмпортныхТоваров");

	// При проведении выполняется контроль превышения остатков на складах.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста") Тогда
		
		Массив.Добавить(Движения.ТоварыНаСкладах);
		Массив.Добавить(Движения.ДвиженияСерийныхНомеров);
		Массив.Добавить(Движения.ЗаказыПокупателей);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

// Проверяет наличие ссылок на текущий документ в проведенных сводных отчетах по кассовой смене.
//
Процедура ПроверитьНаличиеСсылокВСводномОтчетеПоКассовойСмене()
	
	Если ЭтоНовый() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.Ссылка) КАК ПредставлениеСводногоОтчета
	|ИЗ
	|	Документ.СводныйОтчетПоКассовойСмене.ОтчетыОРозничныхПродажах КАК СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах
	|ГДЕ
	|	СводныйОтчетПоКассовойСменеОтчетыОРозничныхПродажах.ОтчетОРозничныхПродажах = &ДокументСсылка";
	
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	Иначе
		
		мТекстСводныхОтчетов = "";
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ПустаяСтрока(мТекстСводныхОтчетов) Тогда
				
				мТекстСводныхОтчетов = мТекстСводныхОтчетов + "," + Символы.ПС;
				
			КонецЕсли;
			
			мТекстСводныхОтчетов = мТекстСводныхОтчетов + " " + Выборка.ПредставлениеСводногоОтчета;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Определим, есть ли отличия.
	мЕстьОтличия = Ложь;
	Если Ссылка.Проведен <> Проведен Тогда
		
		мЕстьОтличия = Истина;
		
	Иначе
		
		Если Ссылка.КассаККМ <> КассаККМ Тогда
			
			мЕстьОтличия = Истина;
			
		Иначе
			
			// Нужно проверять суммы выручки и суммы возвратов.
			ЗапросПоСсылке = Новый Запрос;
			ЗапросПоСсылке.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СУММА(ВложенныйЗапрос.Выручка) КАК Выручка,
			|	СУММА(ВложенныйЗапрос.Возвраты) КАК Возвраты
			|ИЗ
			|	(ВЫБРАТЬ
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахТовары.Количество > 0
			|				ТОГДА ВЫБОР
			|						КОГДА ОтчетОРозничныхПродажахТовары.Ссылка.ЦенаВключаетНДС
			|							ТОГДА ОтчетОРозничныхПродажахТовары.Сумма
			|						ИНАЧЕ ОтчетОРозничныхПродажахТовары.Сумма + ОтчетОРозничныхПродажахТовары.СуммаНДС
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Выручка,
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахТовары.Количество < 0
			|				ТОГДА ВЫБОР
			|						КОГДА ОтчетОРозничныхПродажахТовары.Ссылка.ЦенаВключаетНДС
			|							ТОГДА -ОтчетОРозничныхПродажахТовары.Сумма
			|						ИНАЧЕ -(ОтчетОРозничныхПродажахТовары.Сумма + ОтчетОРозничныхПродажахТовары.СуммаНДС)
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Возвраты,
			|		ОтчетОРозничныхПродажахТовары.Ссылка КАК ОтчетОРозничныхПродажах
			|	ИЗ
			|		Документ.ОтчетОРозничныхПродажах.Товары КАК ОтчетОРозничныхПродажахТовары
			|	ГДЕ
			|		ОтчетОРозничныхПродажахТовары.Ссылка = &ДокументСсылка
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		0,
			|		ВЫБОР
			|			КОГДА ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка.ЦенаВключаетНДС
			|				ТОГДА ОтчетОРозничныхПродажахВозвращенныеТовары.Сумма
			|			ИНАЧЕ ОтчетОРозничныхПродажахВозвращенныеТовары.Сумма + ОтчетОРозничныхПродажахВозвращенныеТовары.СуммаНДС
			|		КОНЕЦ,
			|		ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка
			|	ИЗ
			|		Документ.ОтчетОРозничныхПродажах.ВозвращенныеТовары КАК ОтчетОРозничныхПродажахВозвращенныеТовары
			|	ГДЕ
			|		ОтчетОРозничныхПродажахВозвращенныеТовары.Ссылка = &ДокументСсылка) КАК ВложенныйЗапрос";
			
			ЗапросПоСсылке.УстановитьПараметр("ДокументСсылка", Ссылка);
			
			ВыборкаПоСсылке = ЗапросПоСсылке.Выполнить().Выбрать();
			ВыборкаПоСсылке.Следующий();
			
			ЗапросПоОбъекту = Новый Запрос;
			ЗапросПоОбъекту.Текст =
			"ВЫБРАТЬ
			|	ТабличнаяЧастьТовары.Количество,
			|	ТабличнаяЧастьТовары.Сумма,
			|	ТабличнаяЧастьТовары.СуммаНДС
			|ПОМЕСТИТЬ Товары
			|ИЗ
			|	&ТабличнаяЧастьТовары КАК ТабличнаяЧастьТовары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТабличнаяЧастьВозвращенныеТовары.Сумма,
			|	ТабличнаяЧастьВозвращенныеТовары.СуммаНДС
			|ПОМЕСТИТЬ ВозвращенныеТовары
			|ИЗ
			|	&ТабличнаяЧастьВозвращенныеТовары КАК ТабличнаяЧастьВозвращенныеТовары
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	СУММА(ВложенныйЗапрос.Выручка) КАК Выручка,
			|	СУММА(ВложенныйЗапрос.Возвраты) КАК Возвраты
			|ИЗ
			|	(ВЫБРАТЬ
			|		ВЫБОР
			|			КОГДА Товары.Количество > 0
			|				ТОГДА ВЫБОР
			|						КОГДА &ЦенаВключаетНДС
			|							ТОГДА Товары.Сумма
			|						ИНАЧЕ Товары.Сумма + Товары.СуммаНДС
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Выручка,
			|		ВЫБОР
			|			КОГДА Товары.Количество < 0
			|				ТОГДА ВЫБОР
			|						КОГДА &ЦенаВключаетНДС
			|							ТОГДА -Товары.Сумма
			|						ИНАЧЕ -(Товары.Сумма + Товары.СуммаНДС)
			|					КОНЕЦ
			|			ИНАЧЕ 0
			|		КОНЕЦ КАК Возвраты
			|	ИЗ
			|		Товары КАК Товары
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		0,
			|		ВЫБОР
			|			КОГДА &ЦенаВключаетНДС
			|				ТОГДА ВозвращенныеТовары.Сумма
			|			ИНАЧЕ ВозвращенныеТовары.Сумма + ВозвращенныеТовары.СуммаНДС
			|		КОНЕЦ
			|	ИЗ
			|		ВозвращенныеТовары КАК ВозвращенныеТовары) КАК ВложенныйЗапрос";
			
			ЗапросПоОбъекту.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
			ЗапросПоОбъекту.УстановитьПараметр("ТабличнаяЧастьТовары", Товары);
			ЗапросПоОбъекту.УстановитьПараметр("ТабличнаяЧастьВозвращенныеТовары", ВозвращенныеТовары);
			
			ВыборкаПоОбъекту = ЗапросПоОбъекту.Выполнить().Выбрать();
			ВыборкаПоОбъекту.Следующий();
			
			Если ВыборкаПоСсылке.Выручка <> ВыборкаПоОбъекту.Выручка Или ВыборкаПоСсылке.Возвраты <> ВыборкаПоОбъекту.Возвраты Тогда
				
				мЕстьОтличия = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если мЕстьОтличия Тогда
		
		Заголовок = НСтр("ru = 'Запись документа:'")+ " " + ЭтотОбъект;
		ТекстСообщения = НСтр("ru = 'Изменен документ, который уже был включен в сводный отчет по кассовой смене:'") + " " + мТекстСводныхОтчетов + "! " + 
						 Символы.ПС + НСтр("ru = 'Рекомендуется заново распечатать сводный отчет!'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОсновнойБлок

мТекстСводныхОтчетов = "";
мЕстьОтличия         = Ложь;

#КонецОбласти

#КонецЕсли
