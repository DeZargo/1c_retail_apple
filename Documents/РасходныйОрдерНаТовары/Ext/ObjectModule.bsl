﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет ТЧ Товары остатками основания по регистру ТоварыКОтгрузке.
//
Процедура ЗаполнитьТоварыПоТоварамКОтгрузке() Экспорт
	
	Товары.Очистить();
	СерийныеНомера.Очистить();
	
	Запрос = Новый Запрос;
	
	Текст = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Товары.Цена / ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)) КАК Цена,
	|	МИНИМУМ(Товары.НомерСтроки) КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Товары.Упаковка) > 1
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ МАКСИМУМ(Товары.Упаковка)
	|	КОНЕЦ КАК Упаковка,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Товары.Упаковка) > 1
	|			ТОГДА NULL
	|		ИНАЧЕ МАКСИМУМ(Товары.Упаковка.Коэффициент)
	|	КОНЕЦ КАК Коэффициент,
	|	МИНИМУМ(Товары.КлючСвязиСерийныхНомеров ) КАК КлючСвязиСерийныхНомеров,
	|	СУММА(Товары.Количество) КАК КоличествоОснования
	|ПОМЕСТИТЬ ТоварыОснования
	|ИЗ
	|	Документ.%ВидДокумента%.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОтгрузкеОбороты.Номенклатура КАК Номенклатура,
	|	ТоварыКОтгрузкеОбороты.Характеристика КАК Характеристика,
	|	СУММА(ТоварыКОтгрузкеОбороты.КоличествоОборот) КАК Количество
	|ПОМЕСТИТЬ ТоварыКОтгрузке
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.Обороты(, , Регистратор, ДокументОснование = &ДокументОснование) КАК ТоварыКОтгрузкеОбороты
	|ГДЕ
	|	ТоварыКОтгрузкеОбороты.Регистратор <> &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОтгрузкеОбороты.Номенклатура,
	|	ТоварыКОтгрузкеОбороты.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыКОтгрузкеОбороты.КоличествоОборот) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОснования.НомерСтроки,
	|	ТоварыКОтгрузке.Номенклатура,
	|	ТоварыКОтгрузке.Характеристика,
	|	ТоварыОснования.Цена,
	|	ТоварыКОтгрузке.Количество,
	|	ВЫБОР
	|		КОГДА ТоварыОснования.Коэффициент ЕСТЬ NULL 
	|				ИЛИ (ВЫРАЗИТЬ(ТоварыКОтгрузке.Количество / ТоварыОснования.Коэффициент КАК ЧИСЛО(15, 0))) <> ТоварыКОтгрузке.Количество / ТоварыОснования.Коэффициент
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ИспользоватьУпаковку,
	|	ТоварыОснования.Упаковка,
	|	ТоварыОснования.Коэффициент,
	|	ТоварыОснования.КлючСвязиСерийныхНомеров,
	|	ТоварыОснования.КоличествоОснования,
	|	ВЫБОР
	|		КОГДА ТоварыКОтгрузке.Количество = ТоварыОснования.КоличествоОснования
	|			ТОГДА ТоварыОснования.КлючСвязиСерийныхНомеров
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КлючСвязиСерийныхНомеров
	|ПОМЕСТИТЬ ИтоговаяТаблица
	|ИЗ
	|	ТоварыКОтгрузке КАК ТоварыКОтгрузке
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыОснования КАК ТоварыОснования
	|		ПО ТоварыКОтгрузке.Номенклатура = ТоварыОснования.Номенклатура
	|			И ТоварыКОтгрузке.Характеристика = ТоварыОснования.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИтоговаяТаблица.НомерСтроки КАК НомерСтрокиСорт,
	|	ИтоговаяТаблица.Номенклатура,
	|	ИтоговаяТаблица.Характеристика,
	|	ВЫБОР
	|		КОГДА ИтоговаяТаблица.ИспользоватьУпаковку
	|			ТОГДА ИтоговаяТаблица.Цена * ИтоговаяТаблица.Коэффициент
	|		ИНАЧЕ ИтоговаяТаблица.Цена
	|	КОНЕЦ КАК Цена,
	|	ИтоговаяТаблица.Количество,
	|	ВЫБОР
	|		КОГДА ИтоговаяТаблица.ИспользоватьУпаковку
	|			ТОГДА ИтоговаяТаблица.Количество / ИтоговаяТаблица.Коэффициент
	|		ИНАЧЕ ИтоговаяТаблица.Количество
	|	КОНЕЦ КАК КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА ИтоговаяТаблица.ИспользоватьУпаковку
	|			ТОГДА ИтоговаяТаблица.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Упаковка,
	|	ИтоговаяТаблица.Количество * ИтоговаяТаблица.Цена КАК Сумма,
	|	ИтоговаяТаблица.КлючСвязиСерийныхНомеров
	|ИЗ
	|	ИтоговаяТаблица КАК ИтоговаяТаблица
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиСорт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОснования.КлючСвязиСерийныхНомеров,
	|	СерийныеНомера.СерийныйНомер
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПоступлениеТоваровТовары.Номенклатура КАК Номенклатура,
	|		ПоступлениеТоваровСерийныеНомера.СерийныйНомер КАК СерийныйНомер
	|	ИЗ
	|		Документ.%ВидДокумента%.Товары КАК ПоступлениеТоваровТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%ВидДокумента%.СерийныеНомера КАК ПоступлениеТоваровСерийныеНомера
	|			ПО ПоступлениеТоваровТовары.КлючСвязиСерийныхНомеров = ПоступлениеТоваровСерийныеНомера.КлючСвязиСерийныхНомеров
	|	ГДЕ
	|		ПоступлениеТоваровСерийныеНомера.Ссылка = &ДокументОснование
	|		И ПоступлениеТоваровТовары.Ссылка = &ДокументОснование) КАК СерийныеНомера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварыОснования КАК ТоварыОснования
	|		ПО СерийныеНомера.Номенклатура = ТоварыОснования.Номенклатура
	|ГДЕ
	|	ТоварыОснования.КлючСвязиСерийныхНомеров В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				ИтоговаяТаблица.КлючСвязиСерийныхНомеров
	|			ИЗ
	|				ИтоговаяТаблица КАК ИтоговаяТаблица)";
	
	Запрос.Текст = СтрЗаменить(Текст, "%ВидДокумента%", ДокументОснование.Метаданные().Имя); 
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	Если Не РезультатыЗапроса[3].Пустой() Тогда
		
		Товары.Загрузить(РезультатыЗапроса[3].Выгрузить());
		СерийныеНомера.Загрузить(РезультатыЗапроса[4].Выгрузить());
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Нет данных для заполнения по основанию ""%ДокументОснование%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДокументОснование");
		
	КонецЕсли;
	
	Если Товары.Количество() > 0 Тогда 
		ЗапасыСервер.ЗаполнитьЦеныПоРозничнымЦенам(ЭтотОбъект, "Товары", Магазин, ЗапасыСервер.ДатаДляЦенообразованияДляДокумента(ЭтотОбъект), Ложь);
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.РасходныйОрдерНаТовары.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;	
	
	Справочники.СерийныеНомера.ОчиститьВДокументеНеиспользуемыеСерийныеНомера(Товары, СерийныеНомера);
	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.РасходныйОрдерНаТовары.ПараметрыУказанияСерий(ЭтотОбъект));
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, Истина),
		"СуммаДокумента");

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ДанныеЗаполнения)) Тогда

		ДокументОснование = ДанныеЗаполнения;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ДокументОснование) Тогда

		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование);
		ЗаполнитьПоОснованию();

	Иначе

		ТекстСообщения = НСтр("ru='Расходный ордер можно вводить только на основании распоряжения на отгрузку товаров.'");
		ВызватьИсключение ТекстСообщения;

	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Магазин.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,Документы.РасходныйОрдерНаТовары.ПараметрыУказанияСерий(ЭтотОбъект),Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеТЧПриНаличииОбменаСУправлениемТорговлей(
		ЭтотОбъект, 
		Отказ); 
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеров(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		РеквизитСкладДокументаОснование = "СкладОтправитель";
	Иначе
		РеквизитСкладДокументаОснование = "Склад";
	КонецЕсли;
	СкладДокументаОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, РеквизитСкладДокументаОснование);
	
	Если не Склад = СкладДокументаОснование Тогда
		ТекстСообщения = НСтр("ru = 'Склад документа %1 не соответствует складу основания %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Склад, СкладДокументаОснование);
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			,
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПродажиПоУмолчанию(Магазин,,Склад, Ответственный);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Склад")
			И НЕ ЗначениеЗаполнено(Склад) Тогда
			Если ЗначениеЗаполнено(Магазин) Тогда
				Если НЕ Справочники.Склады.ПроверитьПринадлежностьСкладаМагазину(Магазин, ДанныеЗаполнения.Склад) Тогда
					ДанныеЗаполнения.Склад = Справочники.Склады.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Склад, "Магазин");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоОснованию()

	Реквизиты = Новый Структура("Магазин, Склад, ИспользоватьОрдернуюСхему");

	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда

		Реквизиты.Магазин                   = "МагазинОтправитель";
		Реквизиты.Склад                     = "СкладОтправитель";
		Реквизиты.ИспользоватьОрдернуюСхему = "ЕстьNULL(МагазинОтправитель.ИспользоватьОрдернуюСхемуПриПеремещении, Ложь)";
		
	Иначе

		Реквизиты.Магазин                   = "Магазин";
		Реквизиты.Склад                     = "Склад";		
		Реквизиты.ИспользоватьОрдернуюСхему = "ЕстьNULL(Магазин.ИспользоватьОрдернуюСхемуПриОтгрузке, Ложь)";
		
	КонецЕсли;

	ЗначенияРеквизитов = ОбщегоНазначенияРТ.ПолучитьЗначенияРеквизитовОбъекта(ДокументОснование, Реквизиты);
	Если ЗначенияРеквизитов.ИспользоватьОрдернуюСхему Тогда

		Магазин = ЗначенияРеквизитов.Магазин;
		Склад   = ЗначенияРеквизитов.Склад;
		ЗаполнитьТоварыПоТоварамКОтгрузке();

	Иначе

		ТекстСообщение = НСтр("ru = 'Для магазина ""%Магазин%"" оформление расходных ордеров не требуется.
									|Заполнение документа не выполнено.'");
		ТекстСообщение = СтрЗаменить(ТекстСообщение, "%Магазин%", Строка(ЗначенияРеквизитов.Магазин));

		ВызватьИсключение ТекстСообщение;

	КонецЕсли;

КонецПроцедуры

// Процедура формирует массив имен регистров для контроля проведения.
//
Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	// При проведении выполняется контроль превышения остатков на складах.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Массив.Добавить(Движения.ТоварыНаСкладах);
		Массив.Добавить(Движения.ДвиженияСерийныхНомеров);
		
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
