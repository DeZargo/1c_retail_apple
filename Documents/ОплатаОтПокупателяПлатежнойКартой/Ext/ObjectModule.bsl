﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("ДокументСсылка.РеализацияТоваров")
			ИЛИ ТипОснования = Тип("ДокументСсылка.ВозвратТоваровПоставщику") 
			ИЛИ ТипОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") 
			ИЛИ ТипОснования = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
			
			Если ТипОснования = Тип("ДокументСсылка.ЧекККМ") Тогда
				ПроверитьВозможностьВводаНаОснованииЧекККМ(ДанныеЗаполнения);
			КонецЕсли;
			
			ЗаполнитьПоПоступлениюОплатыОтКлиентаИВозвратаДенежныхСредствОтПоставщика(
				ДанныеЗаполнения,
				ДанныеЗаполнения);
		
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			
			ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
			
			ЗаполнитьПоПоступлениюОплатыОтКлиентаПоЗаказуПокупателя(
				ДанныеЗаполнения,
				ДанныеЗаполнения);
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда
				
		Если ДанныеЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
			
			ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
			
			ЗаполнитьВозвратПокупателюАванса(ДанныеЗаполнения);
			
		Иначе
			ТекстИсключения = НСтр("ru = 'Ввод на основании возможен только для поступления оплаты от покупателя'");
			
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
	ИначеЕсли ТипОснования = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("ЗаполнениеВозвратТоваровОтРозничногоПокупателя") Тогда
			СтрокаПлатежа = РасшифровкаПлатежа.Добавить();
			СтрокаПлатежа.ДокументРасчетовСКонтрагентом = ДанныеЗаполнения.ДокументРасчетовСКонтрагентом;
			СтрокаПлатежа.СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
			СтрокаПлатежа.Сумма = ДанныеЗаполнения.СуммаДокумента;
			РаспределитьОплатуАгентскихПлатежей();
			
			Документы.ОплатаОтПокупателяПлатежнойКартой.ЗаполнениеПризнаковСпособовРасчета(ЭтотОбъект);
		Иначе
			Если ДанныеЗаполнения.Свойство("ЭквайринговыйТерминал", ЭквайринговыйТерминал) И ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
				СтруктураРеквизитов = Справочники.ЭквайринговыеТерминалы.РеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал);
				ДанныеЗаполнения.Вставить("Организация", СтруктураРеквизитов.Организация);
				ДанныеЗаполнения.Вставить("Касса", СтруктураРеквизитов.Касса);
				ДанныеЗаполнения.Вставить("Эквайрер", СтруктураРеквизитов.Эквайрер);
				ДанныеЗаполнения.Вставить("Магазин", ЭквайринговыйТерминал.Магазин);
			Иначе
				Если НЕ ЗначениеЗаполнено(Магазин) Тогда
					Магазин = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущийМагазин", "");
				КонецЕсли;
				ЭквайринговыйТерминал = Справочники.ЭквайринговыеТерминалы.ЭквайринговыйТерминалПоУмолчанию(Неопределено, Организация, Магазин, ВидОплаты);
				Если ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
					СтруктураРеквизитов = Справочники.ЭквайринговыеТерминалы.РеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал);
					ДанныеЗаполнения.Вставить("Касса", СтруктураРеквизитов.Касса);
					ДанныеЗаполнения.Вставить("Эквайрер", СтруктураРеквизитов.Эквайрер);
					ДанныеЗаполнения.Вставить("Магазин", СтруктураРеквизитов.Магазин);
					ДанныеЗаполнения.Вставить("Организация", СтруктураРеквизитов.Организация);
				КонецЕсли;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
				СтруктураПоУмолчанию = Справочники.ЭквайринговыеТерминалы.ВидОплатыПоУмолчанию(ЭквайринговыйТерминал);
				Если ЗначениеЗаполнено(СтруктураПоУмолчанию.ВидОплаты) Тогда
					ДанныеЗаполнения.Вставить("ВидОплаты", СтруктураПоУмолчанию.ВидОплаты);
					ДанныеЗаполнения.Вставить("ПроцентКомиссии", ЭквайрингВызовСервера.ПолучитьПроцентКомиссииДляПлатежнойКарты(ЭквайринговыйТерминал, СтруктураПоУмолчанию.ВидОплаты));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	
	// Инициализация данных документа.
	Документы.ОплатаОтПокупателяПлатежнойКартой.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по денежным средствам.
	ДенежныеСредстваСервер.ОтразитьПродажиПоПлатежнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

// В обработке события "ОбработкаПроверкиЗаполнения" выполняются следующие действия:
// - Устанавливает проверку заполнения реквизитов формы и табличной части "Расшифровка платежа".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ОплатаОтПокупателяПлатежнойКартой.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации
	);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияРТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов
	);
	
	Если ПробиватьЧекиПоКассеККМ И НЕ ЗначениеЗаполнено(КассаККМ) Тогда
		ТекстОшибки = НСтр("ru='Не выбрана касса ККМ!'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			,
			"КассаККМ",
			,
			Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ДенежныеСредстваСервер.ПроверитьЗаполнениеРасшифровкиПлатежа(
		ЭтотОбъект,
		СуммаДокумента,
		ХозяйственнаяОперация,
		Отказ
	);
	
	Если ВидОплаты.ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта Тогда
		Текст = НСтр("ru = 'В документе выбран вид оплаты неверного типа!'");
		ОбщегоНазначения.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"ВидОплаты",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если СменаЗакрыта 
			ИЛИ ПробитЧек 
			ИЛИ ОплатаВыполнена Тогда
			Если СменаЗакрыта Тогда
				Текст = НСтр("ru = 'Кассовая смена закрыта. Операции над этим документом запрещены!'");
				РеквизитДокумента = "ОтчетОРозничныхПродажах"
			ИначеЕсли ПробитЧек Тогда
				Текст = НСтр("ru = 'Пробит чек по документу. Операции над этим документом запрещены!'");
				РеквизитДокумента = "НомерЧекаККМ"
			Иначе
				Текст = НСтр("ru = 'По документу проведена банковская транзакция. Операции над этим документом запрещены!'");
				РеквизитДокумента = "ОплатитьКартой"
			КонецЕсли;
			
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				РеквизитДокумента,
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерЧекаККМ = 0;
	ОплатаВыполнена = Ложь;
	ПробитЧек       = Ложь;
	СменаЗакрыта    = Ложь;
	ОтчетОРозничныхПродажах = Документы.ОтчетОРозничныхПродажах.ПустаяСсылка();
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюОплатыОтКлиентаИВозвратаДенежныхСредствОтПоставщика(Знач ДокументОснование, ДанныеЗаполнения)
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДокументОснования.Ссылка                                КАК ДокументОснование,
	|	МАКСИМУМ(ДокументОснования.Контрагент)                  КАК Контрагент,
	|	МАКСИМУМ(ДокументОснования.Организация)                 КАК Организация,
	|	МАКСИМУМ(ДокументОснования.Магазин)                     КАК Магазин,
	|	МАКСИМУМ(ДокументОснования.СистемаНалогообложения)      КАК СистемаНалогообложения,
	|	МАКСИМУМ(ДокументОснования.ЦенаВключаетНДС)             КАК ЦенаВключаетНДС,
	|	СУММА(ЕСТЬNULL(ТоварыДокументОснования.Сумма, ДокументОснования.СуммаДокумента)) КАК Сумма,
	|	СУММА(ЕСТЬNULL(ТоварыДокументОснования.СуммаНДС, 0.00)) КАК СуммаНДС
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	Документ.РеализацияТоваров КАК ДокументОснования
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.РеализацияТоваров.Товары КАК ТоварыДокументОснования
	|ПО
	|	ТоварыДокументОснования.Ссылка = &Ссылка
	|ГДЕ
	|	ДокументОснования.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ДокументОснования.Ссылка
	|;
	|ВЫБРАТЬ
	|	ДанныеДокумента.ДокументОснование            КАК ДокументОснование,
	|	ДанныеДокумента.Контрагент                   КАК Контрагент,
	|	ДанныеДокумента.Организация                  КАК Организация,
	|	ДанныеДокумента.Магазин                      КАК Магазин,
	|	ДанныеДокумента.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.СистемаНалогообложения       КАК СистемаНалогообложения,
	|	ВЫБОР	КОГДА ДанныеДокумента.ЦенаВключаетНДС
	|			ТОГДА ДанныеДокумента.Сумма
	|			ИНАЧЕ ДанныеДокумента.Сумма + ДанныеДокумента.СуммаНДС
	|	КОНЕЦ                                        КАК СуммаДокумента,
	|	ЕСТЬNULL(Контрагенты.Наименование, "")       КАК Наименование,
	|	ЕСТЬNULL(Контрагенты.НаименованиеПолное, "") КАК НаименованиеПолное
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.Контрагенты КАК Контрагенты
	|ПО
	|	Контрагенты.Ссылка = ДанныеДокумента.Контрагент
	|";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	ЭтоВозврат = Ложь;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров", "Документ.ВозвратТоваровПоставщику");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров.Товары", "Документ.ВозвратТоваровПоставщику.Товары");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДокументОснования.СистемаНалогообложения", "ЗНАЧЕНИЕ(Перечисление.ТипыСистемНалогообложенияККТ.ПустаяСсылка)");
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
		ЭтоВозврат = Истина;
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров", "Документ.ВозвратТоваровОтПокупателя");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров.Товары", "Документ.ВозвратТоваровОтПокупателя.Товары");
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	Иначе
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЧекККМ") Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров", "Документ.ЧекККМ");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.РеализацияТоваров.Товары", "Документ.ЧекККМ.Товары");
			ЗаказПокупателя = ДокументОснование.ЗаказПокупателя;
		ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваров") Тогда
			ЗаказПокупателя = ДокументОснование.ЗаказПокупателя;
		КонецЕсли;
		Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет()[1];
	ДанныеЗаполнения = Новый Структура();
	
	Для Каждого РеквизитЗаполнения Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(РеквизитЗаполнения.Имя);
	КонецЦикла;
	ВыборкаДанныхЗаполнения = РезультатЗапроса.Выбрать();
	ВыборкаДанныхЗаполнения.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ВыборкаДанныхЗаполнения);
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.СуммаДокумента) Тогда
		ПроцентКомиссии = ЭквайрингВызовСервера.ПолучитьПроцентКомиссииДляПлатежнойКарты(ЭквайринговыйТерминал, ВидОплаты, ЭтоВозврат);
		ДанныеЗаполнения.Вставить("СуммаКомиссии", СуммаДокумента * ПроцентКомиссии / 100.00);
	КонецЕсли;
	
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(ДанныеЗаполнения.ХозяйственнаяОперация);
	ДенежныеСредстваСервер.ЗаполнитьРеквизитыДокументаПоФормеОплаты(ДанныеЗаполнения, ,ЭтоВозврат);
	
	СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
	СтрокаПлатеж.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
	СтрокаПлатеж.ДокументРасчетовСКонтрагентом = ДокументОснование; // Для Заказа покупателя подставится пустая ссылка
	СтрокаПлатеж.Сумма                         = ВыборкаДанныхЗаполнения.СуммаДокумента;
	
	РаспределитьОплатуАгентскихПлатежей();
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюОплатыОтКлиентаПоЗаказуПокупателя(Знач ДокументОснование, ДанныеЗаполнения)
	Запрос = Новый Запрос();
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДокументОснования.Ссылка                                КАК ДокументОснование,
	|	МАКСИМУМ(ДокументОснования.Контрагент)                  КАК Контрагент,
	|	МАКСИМУМ(ДокументОснования.Организация)                 КАК Организация,
	|	МАКСИМУМ(ДокументОснования.Магазин)                     КАК Магазин,
	|	МАКСИМУМ(ДокументОснования.ЦенаВключаетНДС)             КАК ЦенаВключаетНДС,
	|	СУММА(ЕСТЬNULL(ТоварыДокументОснования.Сумма, ДокументОснования.СуммаДокумента)) КАК Сумма,
	|	СУММА(ЕСТЬNULL(ТоварыДокументОснования.СуммаНДС, 0.00)) КАК СуммаНДС
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ДокументОснования
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЗаказПокупателя.Товары КАК ТоварыДокументОснования
	|ПО
	|	ТоварыДокументОснования.Ссылка = &Ссылка
	|ГДЕ
	|	ДокументОснования.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ДокументОснования.Ссылка
	|;
	|ВЫБРАТЬ
	|	ДанныеДокумента.ДокументОснование            КАК ДокументОснование,
	|	ДанныеДокумента.Контрагент                   КАК Контрагент,
	|	ДанныеДокумента.Организация                  КАК Организация,
	|	ДанныеДокумента.Магазин                      КАК Магазин,
	|	ДанныеДокумента.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация,
	|	ВЫБОР	КОГДА ДанныеДокумента.ЦенаВключаетНДС
	|			ТОГДА ДанныеДокумента.Сумма
	|			ИНАЧЕ ДанныеДокумента.Сумма + ДанныеДокумента.СуммаНДС
	|	КОНЕЦ                                        КАК СуммаДокумента,
	|	ЕСТЬNULL(Контрагенты.Наименование, "")       КАК Наименование,
	|	ЕСТЬNULL(Контрагенты.НаименованиеПолное, "") КАК НаименованиеПолное
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.Контрагенты КАК Контрагенты
	|ПО
	|	Контрагенты.Ссылка = ДанныеДокумента.Контрагент
	|";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	
	ЗаказПокупателя = ДокументОснование;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет()[1];
	ДанныеЗаполнения = Новый Структура();
	
	Для Каждого РеквизитЗаполнения Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(РеквизитЗаполнения.Имя);
	КонецЦикла;
	ВыборкаДанныхЗаполнения = РезультатЗапроса.Выбрать();
	ВыборкаДанныхЗаполнения.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ВыборкаДанныхЗаполнения);
	
	СуммаДокументаОснования = ВыборкаДанныхЗаполнения.СуммаДокумента;
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(ДанныеЗаполнения.ХозяйственнаяОперация);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток КАК СуммаОстаток,
	|	РасчетыСКлиентамиОстатки.ДокументРасчета КАК ДокументРасчета
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(, ЗаказПокупателя = &ЗаказПокупателя) КАК РасчетыСКлиентамиОстатки
	|ГДЕ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток < 0";
	
	Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя);
	
	Результат = Запрос.Выполнить();
	НабраннаяСумма = 0;
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		
		Пока ВыБорка.Следующий() Цикл
			СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
			СтрокаПлатеж.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
			СтрокаПлатеж.ДокументРасчетовСКонтрагентом = ВыБорка.ДокументРасчета;
			СтрокаПлатеж.Сумма                         = - ВыБорка.СуммаОстаток;
			НабраннаяСумма = НабраннаяСумма + СтрокаПлатеж.Сумма
		КонецЦикла;
		
	КонецЕсли;
	
	Если НабраннаяСумма < СуммаДокументаОснования Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	РасчетыСКлиентамиОбороты.СуммаПриход КАК СуммаПриход
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами.Обороты(, , , ЗаказПокупателя = &ЗаказПокупателя) КАК РасчетыСКлиентамиОбороты";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Предопреоплата = 0;
		Если Выборка.Следующий() Тогда
			Предопреоплата = ВыБорка.СуммаПриход;
		КонецЕсли;
		
		ОстатокЗаказа = СуммаДокументаОснования - (НабраннаяСумма + Предопреоплата);
		Если ОстатокЗаказа > 0  Тогда
			СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
			СтрокаПлатеж.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
			СтрокаПлатеж.Сумма                         = ОстатокЗаказа;
		КонецЕсли;
	КонецЕсли;
	
	Если РасшифровкаПлатежа.Количество() = 0 Тогда
		СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
		СтрокаПлатеж.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		СтрокаПлатеж.Сумма                         = СуммаДокументаОснования;
	КонецЕсли;
	
	РаспределитьОплатуАгентскихПлатежей();
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("Сумма");
	ДанныеЗаполнения.СуммаДокумента = СуммаДокумента;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.СуммаДокумента) Тогда
		ПроцентКомиссии = ЭквайрингВызовСервера.ПолучитьПроцентКомиссииДляПлатежнойКарты(ЭквайринговыйТерминал, ВидОплаты, Ложь);
		ДанныеЗаполнения.Вставить("СуммаКомиссии", СуммаДокумента * ПроцентКомиссии / 100.00);
	КонецЕсли;
	
	ДенежныеСредстваСервер.ЗаполнитьРеквизитыДокументаПоФормеОплаты(ДанныеЗаполнения, ,ЛОжь);
	
КонецПроцедуры

Процедура ЗаполнитьВозвратПокупателюАванса(ДанныеЗаполнения)
	
	РеквизитыИсключаемыеИзЗаполнения = "Номер, ПробитЧек, НомерЧекаККМ, ХозяйственнаяОперация, Ответственный, СменаЗакрыта, ОтработанПереход, РасшифровкаПлатежа";
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,РеквизитыИсключаемыеИзЗаполнения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток КАК СуммаОстаток
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки КАК РасчетыСКлиентамиОстатки
	|ГДЕ
	|	РасчетыСКлиентамиОстатки.ДокументРасчета = &ДокументРасчета";
	
	Запрос.УстановитьПараметр("ДокументРасчета", ДанныеЗаполнения);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту;
	Ответственный = Пользователи.ТекущийПользователь();
	СтатьяДвиженияДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьСтатьюДвиженияДенежныхСредств(ХозяйственнаяОперация);
	Если Выборка.Следующий() Тогда
		
		СтрокаРасчета = РасшифровкаПлатежа.Добавить();
		СтрокаРасчета.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		СтрокаРасчета.ДокументРасчетовСКонтрагентом = ДанныеЗаполнения;
		СтрокаРасчета.ДоговорПлатежногоАгента = ДанныеЗаполнения.ДоговорПлатежногоАгента;
		СтрокаРасчета.Сумма = Выборка.СуммаОстаток;
		СуммаДокумента = СтрокаРасчета.Сумма;
	Иначе
		СтрокаРасчета = РасшифровкаПлатежа.Добавить();
		СтрокаРасчета.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
		СтрокаРасчета.ДоговорПлатежногоАгента = ДанныеЗаполнения.ДоговорПлатежногоАгента;
		СтрокаРасчета.Сумма = ДанныеЗаполнения.СуммаДокумента;
		СуммаДокумента = СтрокаРасчета.Сумма;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	ОплатаВыполнена     = Ложь;
	НомерПлатежнойКарты = "";
	НомерЧекаККМ        = 0;
	Ответственный       = Пользователи.ТекущийПользователь();
	
	ДенежныеСредстваСервер.ЗаполнитьСистемуНалогообложения(ЭтотОбъект);
	
КонецПроцедуры

Процедура РаспределитьОплатуАгентскихПлатежей()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	РасшифровкаПлатежа.Сумма КАК Сумма
	|ПОМЕСТИТЬ РасшифровкаПлатежаНачальная
	|ИЗ
	|	&РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	СУММА(РасшифровкаПлатежа.Сумма) КАК Сумма
	|ПОМЕСТИТЬ РасшифровкаПлатежа
	|ИЗ
	|	РасшифровкаПлатежаНачальная КАК РасшифровкаПлатежа
	|
	|СГРУППИРОВАТЬ ПО
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК ДокументРасчетов,
	|	Товары.Номенклатура.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	СУММА(Товары.Сумма) КАК Сумма
	|ПОМЕСТИТЬ Договоры
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В
	|			(ВЫБРАТЬ
	|				РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом
	|			ИЗ
	|				РасшифровкаПлатежа КАК РасшифровкаПлатежа)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка,
	|	Товары.Номенклатура.ДоговорПлатежногоАгента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Товары.Ссылка,
	|	Товары.Номенклатура.ДоговорПлатежногоАгента,
	|	СУММА(Товары.Сумма)
	|ИЗ
	|	Документ.РеализацияТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В
	|			(ВЫБРАТЬ
	|				РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом
	|			ИЗ
	|				РасшифровкаПлатежа КАК РасшифровкаПлатежа)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Ссылка,
	|	Товары.Номенклатура.ДоговорПлатежногоАгента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,
	|	РасшифровкаПлатежа.Сумма КАК СуммаПоДокументу,
	|	Договоры.ДокументРасчетов,
	|	Договоры.ДоговорПлатежногоАгента,
	|	Договоры.Сумма КАК Сумма
	|ИЗ
	|	РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|		ЛЕВОЕ СОЕДИНЕНИЕ Договоры КАК Договоры
	|		ПО (Договоры.ДокументРасчетов = РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом)
	|ИТОГИ ПО
	|	ДокументРасчетовСКонтрагентом";
	Запрос.УстановитьПараметр("РасшифровкаПлатежа", РасшифровкаПлатежа.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	РасшифровкаПлатежа.Очистить();
	Пока Выборка.Следующий() Цикл
		ВыборкаДокументы = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДокументы.Следующий() Цикл
			НоваяСтрока = РасшифровкаПлатежа.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДокументы);
			Если НЕ ЗначениеЗаполнено(НоваяСтрока.Сумма) Тогда
				НоваяСтрока.Сумма = ВыборкаДокументы.СуммаПоДокументу;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьВозможностьВводаНаОснованииЧекККМ(ДанныеЗаполнения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЧекККМОплата.ВидОплаты
	|ИЗ
	|	Документ.ЧекККМ.Оплата КАК ЧекККМОплата
	|ГДЕ
	|	ЧекККМОплата.Ссылка = &Ссылка
	|	И ЧекККМОплата.ВидОплаты.ТипОплаты = &ТипОплаты";
	
	Запрос.УстановитьПараметр("Ссылка"   , ДанныеЗаполнения);
	Запрос.УстановитьПараметр("ТипОплаты", Перечисления.ТипыОплатЧекаККМ.ВРассрочку);
	
	Если Запрос.Выполнить().Пустой() Тогда
		
		ТесктИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														НСтр("ru = 'По чеку %1 отсутствуют оплаты в рассрочку.'"), ДанныеЗаполнения);
		
		ВызватьИсключение ТесктИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
