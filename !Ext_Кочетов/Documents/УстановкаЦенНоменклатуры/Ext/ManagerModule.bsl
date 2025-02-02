﻿#Если сервер тогда


&Вместо("ПечатьУстановкаЦенНоменклатуры")
// Функция формирует табличный документ с печатной формой установки цен номенклатуры.
//
// Возвращаемое значение:
//  Табличный документ.
//
Функция ВместоПечатьУстановкаЦенНоменклатурыКочетов(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УстановкаЦенНоменклатуры";
	
	Макет = Документы.УстановкаЦенНоменклатуры.ПолучитьМакет("ПФ_MXL_УстановкаЦенНоменклатурыШтрихкоды");//УправлениеПечатью.МакетПечатнойФормы("Документ.УстановкаЦенНоменклатуры.ПФ_MXL_УстановкаЦенНоменклатуры");
	
	ВидыЦен = Новый Массив;
	ДеревоНастроек = ПолучитьИзВременногоХранилища(ПараметрыПечати.ДеревоНастроек);
	Для Каждого СтрокаДерева Из ДеревоНастроек.Строки Цикл
		Если СтрокаДерева.ВыводитьНаПечать Тогда
			ВидыЦен.Добавить(СтрокаДерева.Параметр);
		КонецЕсли;
	КонецЦикла;
	
	ПервыйДокумент = Истина;
	Для Каждого УстановкаЦенНоменклатуры Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		




		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УстановкаЦенНоменклатуры.Ссылка КАК Ссылка,
		|	УстановкаЦенНоменклатуры.Ссылка.Номер КАК Номер,
		|	УстановкаЦенНоменклатуры.Ссылка.Дата КАК Дата,
		|	УстановкаЦенНоменклатуры.Ответственный.ФизЛицо КАК Ответственный
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры КАК УстановкаЦенНоменклатуры
		|ГДЕ
		|	УстановкаЦенНоменклатуры.Ссылка = &УстановкаЦенНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Упаковка КАК Упаковка,
		|	Товары.Цена КАК Цена,
		|	Товары.ВидЦены КАК ВидЦены,
		|	ВЫБОР
		|		КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|			ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|		ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|	КОНЕЦ КАК ДействующаяЦена,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) <> 0
		|				ТОГДА 100 * (Товары.Цена - ВЫБОР
		|						КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|							ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|						ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|					КОНЕЦ) / ВЫБОР
		|						КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|							ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|						ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ КАК ЧИСЛО(19, 2)) КАК ПроцентИзменения
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры.Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&ДатаСреза,
		|				(Номенклатура, Характеристика, ВидЦены) В
		|					(ВЫБРАТЬ
		|						Т.Номенклатура,
		|						Т.Характеристика,
		|						Т.ВидЦены
		|					ИЗ
		|						Документ.УстановкаЦенНоменклатуры.Товары КАК Т
		|					ГДЕ
		|						Т.Ссылка = &УстановкаЦенНоменклатуры
		|						И Т.ВидЦены В (&ВидыЦен))) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО Товары.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			И Товары.Характеристика = ЦеныНоменклатурыСрезПоследних.Характеристика
		|			И Товары.ВидЦены = ЦеныНоменклатурыСрезПоследних.ВидЦены
		|ГДЕ
		|	Товары.Ссылка = &УстановкаЦенНоменклатуры
		|	И Товары.ВидЦены В(&ВидыЦен)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УстановкаЦенНоменклатурыТовары.ВидЦены КАК ВидЦены,
		|	УстановкаЦенНоменклатурыТовары.Цена КАК Цена,
		|	УстановкаЦенНоменклатурыТовары.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ТоварыДляНаценки
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|ГДЕ
		|	УстановкаЦенНоменклатурыТовары.Ссылка = &УстановкаЦенНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	(розница.Цена - Закуп.Цена) / Закуп.Цена КАК Наценка
		|ПОМЕСТИТЬ Наценки
		|ИЗ
		|	ТоварыДляНаценки КАК Закуп
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварыДляНаценки КАК розница
		|		ПО Закуп.Номенклатура = розница.Номенклатура
		|ГДЕ
		|	Закуп.ВидЦены = &Закуп
		|	И розница.ВидЦены = &Розница
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Товары.ВидЦены КАК ВидЦены
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	(Товары.ВидЦены В (&ВидыЦен)
		|				И (Товары.ПроцентИзменения <> 0
		|					ИЛИ Товары.ДействующаяЦена = 0)
		|			ИЛИ &Все)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.ВидЦены.РеквизитДопУпорядочивания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Номенклатура.НаименованиеПолное КАК ПолноеНаименованиеНоменклатуры,
		|	Товары.Характеристика.Наименование КАК ПолноеНаименованиеХарактеристики,
		|	Товары.Номенклатура.Код КАК Код,
		|	Товары.Номенклатура.Артикул КАК Артикул,
		|	Товары.Упаковка КАК Упаковка,
		|	Товары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Товары.Цена КАК Цена,
		|	Товары.ВидЦены КАК ВидЦены,
		|	Товары.ДействующаяЦена КАК СтараяЦена,
		|	Товары.ПроцентИзменения КАК ПроцентИзменения,
		|	Наценки.Наценка КАК Нфываценка,
		|	ЕСТЬNULL(ЕСТЬNULL(Наценки.Наценка * 100, ВЫБОР
		|				КОГДА Товары.ВидЦены = &Закуп
		|					ТОГДА 100 * (Розница.Цена - Товары.Цена) / Товары.Цена
		|				ИНАЧЕ ВЫБОР
		|						КОГДА Товары.ВидЦены = &Розница
		|							ТОГДА 100 * (-Закуп.Цена + Товары.Цена) / Закуп.Цена
		|					КОНЕЦ
		|			КОНЕЦ), 0) КАК Наценка
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ВидЦены = &Закуп) КАК Закуп
		|		ПО Товары.Номенклатура = Закуп.Номенклатура
		|			И Товары.ВидЦены <> Закуп.ВидЦены
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ВидЦены = &Розница) КАК Розница
		|		ПО Товары.Номенклатура = Розница.Номенклатура
		|			И Товары.ВидЦены <> Розница.ВидЦены
		|		ЛЕВОЕ СОЕДИНЕНИЕ Наценки КАК Наценки
		|		ПО Товары.Номенклатура = Наценки.Номенклатура
		|ГДЕ
		|	(Товары.ПроцентИзменения <> 0
		|			ИЛИ Товары.ДействующаяЦена = 0
		|			ИЛИ &Все)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.НомерСтроки
		|ИТОГИ
		|	МАКСИМУМ(Нфываценка),
		|	МАКСИМУМ(Наценка)
		|ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	(Розница.Цена - Закуп.Цена) / Закуп.Цена КАК Наценка
		|ИЗ
		|	Товары КАК Закуп
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Товары КАК Розница
		|		ПО Закуп.Номенклатура = Розница.Номенклатура
		|ГДЕ
		|	Закуп.ВидЦены = &Закуп
		|	И Розница.ВидЦены = &Розница
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	Закуп.Цена КАК Наценка,
		|	Закуп.ВидЦены КАК ВидЦены
		|ИЗ
		|	Товары КАК Закуп");
		Запрос.УстановитьПараметр("УстановкаЦенНоменклатуры", УстановкаЦенНоменклатуры);
		Запрос.УстановитьПараметр("ДатаСреза",                УстановкаЦенНоменклатуры.Дата - 1);
		Запрос.УстановитьПараметр("ВидыЦен",                  ВидыЦен);
		Запрос.УстановитьПараметр("Розница",Справочники.ххх_Справочник.РозничнаяЦена.Значение.Ссылка);
		Запрос.УстановитьПараметр("Закуп",Справочники.ххх_Справочник.ЗакупочнаяЦена.Значение.Ссылка);
		Запрос.УстановитьПараметр("Все",                      Не ПараметрыПечати.ПечататьТолькоИзмененныеЦены);
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		
		Шапка = РезультатЗапроса[0].Выбрать();
		Шапка.Следующий();
		
		Если ПараметрыПечати.ВыводитьШапку Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
			ОбластьМакета.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Установка цен номенклатуры'"));
			ОбластьМакета.Параметры.ТекстЗаголовка=ОбластьМакета.Параметры.ТекстЗаголовка+
				"            "+?(ТипЗнч(УстановкаЦенНоменклатуры.ДокументОснование)=Тип("ДокументСсылка.ПоступлениеТоваров"),
				УстановкаЦенНоменклатуры.ДокументОснование.Контрагент,"");
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// Шапка таблицы
		КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
		ВыводитьКоды = ?(ЗначениеЗаполнено(КолонкаКодов),Истина, Ложь);
		
		ШапкаНомера  = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьНомера");
		ШапкаКодов   = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьКодов");
		ШапкаТовар   = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьТовар");
		ШапкаВидЦены = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
		ШапкаУникальныеИдентификаторы = Макет.ПолучитьОбласть("ШапкаТаблицы|УникальныеИдентификаторы");
		
		ТабДокумент.Вывести(ШапкаНомера);
		Если ВыводитьКоды Тогда
			ШапкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов;
			ТабДокумент.Присоединить(ШапкаКодов);
		КонецЕсли;
		Если Не ПараметрыПечати.ВыводитьШапку Тогда
			ТабДокумент.Присоединить(ШапкаУникальныеИдентификаторы);
		КонецЕсли;
		ТабДокумент.Присоединить(ШапкаТовар);
		
		
		Табл = Новый ТаблицаЗначений;
		Табл.Колонки.Добавить("ВидЦены");
		Табл.Колонки.Добавить("МакетОбласти");
				
		ВыборкаПоВидамЦен = РезультатЗапроса[4].Выбрать();
		Пока ВыборкаПоВидамЦен.Следующий() Цикл
			
			Новая                          = Табл.Добавить();
			Новая.ВидЦены                  = ВыборкаПоВидамЦен.ВидЦены;
		
					
			ШапкаВидЦены       = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
			Новая.МакетОбласти = Макет.ПолучитьОбласть("Строка|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
						
			ШапкаВидЦены.Параметры.ВидЦены = ВыборкаПоВидамЦен.ВидЦены;
			ТабДокумент.Присоединить(ШапкаВидЦены);
			
		КонецЦикла;		
		
		ОбластьНомера = Макет.ПолучитьОбласть("Строка|ОбластьНомера");
		ОбластьКодов  = Макет.ПолучитьОбласть("Строка|ОбластьКодов");
		ОбластьТовар  = Макет.ПолучитьОбласть("Строка|ОбластьТовар");
		ОбластьУникальныеИдентификаторы = Макет.ПолучитьОбласть("Строка|УникальныеИдентификаторы");
		
		НомерСтроки = 0;
		ВыборкаПоНоменклатуре = РезультатЗапроса[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоНоменклатуре.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ВыборкаПоНоменклатуре.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;
			
			ВыборкаПоХарактеристикам = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоХарактеристикам.Следующий() Цикл
			
				НомерСтроки = НомерСтроки + 1;
				
				ОбластьНомера.Параметры.НомерСтроки = НомерСтроки;
				ТабДокумент.Вывести(ОбластьНомера);
				Если ВыводитьКоды Тогда
					
					Если КолонкаКодов = "Артикул" Тогда
						ОбластьКодов.Параметры.Артикул = ВыборкаПоНоменклатуре.Артикул;
					Иначе
						ОбластьКодов.Параметры.Артикул = ВыборкаПоНоменклатуре.Код;
					КонецЕсли;
					
					ТабДокумент.Присоединить(ОбластьКодов);
					
				КонецЕсли;
				
				Если Не ПараметрыПечати.ВыводитьШапку Тогда
					ОбластьУникальныеИдентификаторы.Параметры.УникальныйИдентификаторНоменклатура   = ВыборкаПоХарактеристикам.Номенклатура.УникальныйИдентификатор();
					ОбластьУникальныеИдентификаторы.Параметры.УникальныйИдентификаторХарактеристика = ВыборкаПоХарактеристикам.Характеристика.УникальныйИдентификатор();
					ТабДокумент.Присоединить(ОбластьУникальныеИдентификаторы);
				КонецЕсли;
				
				ОбластьТовар.Параметры.Заполнить(ВыборкаПоХарактеристикам);
				ОбластьТовар.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоХарактеристикам.ПолноеНаименованиеНоменклатуры, ВыборкаПоХарактеристикам.ПолноеНаименованиеХарактеристики);
				ОбластьТовар.Параметры.Наценка=?(ВыборкаПоХарактеристикам.Наценка<=0,ВыборкаПоХарактеристикам.Наценка,".");
				
				
				
				
				
				Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
			    КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;

				Наб=РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
				Наб.отбор.Владелец.установить(ВыборкаПоХарактеристикам.Номенклатура);
				Наб.отбор.ТипШтрихкода.установить(ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13);
				наб.Прочитать();
				
				Штрихкод="";
				Если наб.Количество()>0 Тогда
					Штрихкод=наб[0].Штрихкод;
				КонецЕсли;
				
				ПараметрыШтрихкода = Новый Структура;
				ПараметрыШтрихкода.Вставить("Ширина",	20);//Окр(ОблЦена.Рисунки.Штрихкод.Ширина /КоличествоМиллиметровВПикселе));
				ПараметрыШтрихкода.Вставить("Высота",	10);
				ПараметрыШтрихкода.Вставить("Штрихкод",				Штрихкод);
				ПараметрыШтрихкода.Вставить("ТипКода",				1);
				ПараметрыШтрихкода.Вставить("ОтображатьТекст",		ложь);
				ПараметрыШтрихкода.Вставить("РазмерШрифта",			8);
				ПараметрыШтрихкода.Вставить("УголПоворота",		0);

				ОбластьТовар.Рисунки.Штрихкод.картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
				
				
				ОбластьТовар.Параметры.Штрихкод = Штрихкод;

				
				
				ТабДокумент.Присоединить(ОбластьТовар);
				
				ВыборкаПоВидамЦен = ВыборкаПоХарактеристикам.Выбрать();
				Для Каждого СтрокаТЗ Из Табл Цикл
					

					ВыборкаПоВидамЦен.Сбросить();
					Если ВыборкаПоВидамЦен.НайтиСледующий(Новый Структура("ВидЦены", СтрокаТЗ.ВидЦены)) Тогда
						
						ОбластьВидЦены = СтрокаТЗ.МакетОбласти;
						ОбластьВидЦены.Параметры.Цена = ВыборкаПоВидамЦен.Цена;	
						//Zorius
						ОбластьВидЦены.Параметры.СтараяЦена = ВыборкаПоВидамЦен.СтараяЦена;	
						//Zorius

						Если Не ПараметрыПечати.ВыводитьШапку Тогда
							ОбластьВидЦены.Параметры.УникальныйИдентификаторЕдиницаИзмерения = ВыборкаПоВидамЦен.Упаковка.УникальныйИдентификатор();
						КонецЕсли;
						
					Иначе
						
						ОбластьВидЦены = СтрокаТЗ.МакетОбласти;
						ОбластьВидЦены.Параметры.Цена = "";
						ОбластьВидЦены.Параметры.СтараяЦена = "";	

						//Zorius

						//ОбластьВидЦены.Параметры.ЕдиницаИзмерения = Неопределено;
						//
						//Если Не ПараметрыПечати.ВыводитьШапку Тогда
						//	ОбластьВидЦены.Параметры.УникальныйИдентификаторЕдиницаИзмерения = Справочники.УпаковкиНоменклатуры.ПустаяСсылка().УникальныйИдентификатор();
						//КонецЕсли;
						//Zorius

					КонецЕсли;
					
					ТабДокумент.Присоединить(ОбластьВидЦены);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если ПараметрыПечати.ВыводитьШапку Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
			ОбластьМакета.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Шапка.Ответственный);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, УстановкаЦенНоменклатуры);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции


// Функция формирует табличный документ с печатной формой установки цен номенклатуры.
//
// Возвращаемое значение:
//  Табличный документ.
//
Функция ПечатьУстановкаЦенНоменклатурыКочетов(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УстановкаЦенНоменклатуры";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УстановкаЦенНоменклатуры.ПФ_MXL_УстановкаЦенНоменклатуры");
	
	ВидыЦен = Новый Массив;
	ДеревоНастроек = ПолучитьИзВременногоХранилища(ПараметрыПечати.ДеревоНастроек);
	Для Каждого СтрокаДерева Из ДеревоНастроек.Строки Цикл
		Если СтрокаДерева.ВыводитьНаПечать Тогда
			ВидыЦен.Добавить(СтрокаДерева.Параметр);
		КонецЕсли;
	КонецЦикла;
	
	ПервыйДокумент = Истина;
	Для Каждого УстановкаЦенНоменклатуры Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		




		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УстановкаЦенНоменклатуры.Ссылка КАК Ссылка,
		|	УстановкаЦенНоменклатуры.Ссылка.Номер КАК Номер,
		|	УстановкаЦенНоменклатуры.Ссылка.Дата КАК Дата,
		|	УстановкаЦенНоменклатуры.Ответственный.ФизЛицо КАК Ответственный
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры КАК УстановкаЦенНоменклатуры
		|ГДЕ
		|	УстановкаЦенНоменклатуры.Ссылка = &УстановкаЦенНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Упаковка КАК Упаковка,
		|	Товары.Цена КАК Цена,
		|	Товары.ВидЦены КАК ВидЦены,
		|	ВЫБОР
		|		КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|			ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|		ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|	КОНЕЦ КАК ДействующаяЦена,
		|	ВЫРАЗИТЬ(ВЫБОР
		|			КОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) <> 0
		|				ТОГДА 100 * (Товары.Цена - ВЫБОР
		|						КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|							ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|						ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|					КОНЕЦ) / ВЫБОР
		|						КОГДА ЦеныНоменклатурыСрезПоследних.Упаковка = Товары.Упаковка
		|							ТОГДА ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0)
		|						ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) * ЕСТЬNULL(Товары.Упаковка.Коэффициент, 1)
		|					КОНЕЦ
		|			ИНАЧЕ 0
		|		КОНЕЦ КАК ЧИСЛО(19, 2)) КАК ПроцентИзменения
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры.Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&ДатаСреза,
		|				(Номенклатура, Характеристика, ВидЦены) В
		|					(ВЫБРАТЬ
		|						Т.Номенклатура,
		|						Т.Характеристика,
		|						Т.ВидЦены
		|					ИЗ
		|						Документ.УстановкаЦенНоменклатуры.Товары КАК Т
		|					ГДЕ
		|						Т.Ссылка = &УстановкаЦенНоменклатуры
		|						И Т.ВидЦены В (&ВидыЦен))) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО Товары.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			И Товары.Характеристика = ЦеныНоменклатурыСрезПоследних.Характеристика
		|			И Товары.ВидЦены = ЦеныНоменклатурыСрезПоследних.ВидЦены
		|ГДЕ
		|	Товары.Ссылка = &УстановкаЦенНоменклатуры
		|	И Товары.ВидЦены В(&ВидыЦен)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УстановкаЦенНоменклатурыТовары.ВидЦены КАК ВидЦены,
		|	УстановкаЦенНоменклатурыТовары.Цена КАК Цена,
		|	УстановкаЦенНоменклатурыТовары.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ТоварыДляНаценки
		|ИЗ
		|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|ГДЕ
		|	УстановкаЦенНоменклатурыТовары.Ссылка = &УстановкаЦенНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	(розница.Цена - Закуп.Цена) / Закуп.Цена КАК Наценка
		|ПОМЕСТИТЬ Наценки
		|ИЗ
		|	ТоварыДляНаценки КАК Закуп
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТоварыДляНаценки КАК розница
		|		ПО Закуп.Номенклатура = розница.Номенклатура
		|ГДЕ
		|	Закуп.ВидЦены = &Закуп
		|	И розница.ВидЦены = &Розница
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	Товары.ВидЦены КАК ВидЦены
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	(Товары.ВидЦены В (&ВидыЦен)
		|				И (Товары.ПроцентИзменения <> 0
		|					ИЛИ Товары.ДействующаяЦена = 0)
		|			ИЛИ &Все)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.ВидЦены.РеквизитДопУпорядочивания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика,
		|	Товары.Номенклатура.НаименованиеПолное КАК ПолноеНаименованиеНоменклатуры,
		|	Товары.Характеристика.Наименование КАК ПолноеНаименованиеХарактеристики,
		|	Товары.Номенклатура.Код КАК Код,
		|	Товары.Номенклатура.Артикул КАК Артикул,
		|	Товары.Упаковка КАК Упаковка,
		|	Товары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Товары.Цена КАК Цена,
		|	Товары.ВидЦены КАК ВидЦены,
		|	Товары.ДействующаяЦена КАК СтараяЦена,
		|	Товары.ПроцентИзменения КАК ПроцентИзменения,
		|	Наценки.Наценка КАК Нфываценка,
		|	ЕСТЬNULL(ЕСТЬNULL(Наценки.Наценка * 100, ВЫБОР
		|				КОГДА Товары.ВидЦены = &Закуп
		|					ТОГДА 100 * (Розница.Цена - Товары.Цена) / Товары.Цена
		|				ИНАЧЕ ВЫБОР
		|						КОГДА Товары.ВидЦены = &Розница
		|							ТОГДА 100 * (-Закуп.Цена + Товары.Цена) / Закуп.Цена
		|					КОНЕЦ
		|			КОНЕЦ), 0) КАК Наценка
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ВидЦены = &Закуп) КАК Закуп
		|		ПО Товары.Номенклатура = Закуп.Номенклатура
		|			И Товары.ВидЦены <> Закуп.ВидЦены
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ВидЦены = &Розница) КАК Розница
		|		ПО Товары.Номенклатура = Розница.Номенклатура
		|			И Товары.ВидЦены <> Розница.ВидЦены
		|		ЛЕВОЕ СОЕДИНЕНИЕ Наценки КАК Наценки
		|		ПО Товары.Номенклатура = Наценки.Номенклатура
		|ГДЕ
		|	(Товары.ПроцентИзменения <> 0
		|			ИЛИ Товары.ДействующаяЦена = 0
		|			ИЛИ &Все)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.НомерСтроки
		|ИТОГИ
		|	МАКСИМУМ(Нфываценка),
		|	МАКСИМУМ(Наценка)
		|ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	(Розница.Цена - Закуп.Цена) / Закуп.Цена КАК Наценка
		|ИЗ
		|	Товары КАК Закуп
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Товары КАК Розница
		|		ПО Закуп.Номенклатура = Розница.Номенклатура
		|ГДЕ
		|	Закуп.ВидЦены = &Закуп
		|	И Розница.ВидЦены = &Розница
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Закуп.Номенклатура КАК Номенклатура,
		|	Закуп.Цена КАК Наценка,
		|	Закуп.ВидЦены КАК ВидЦены
		|ИЗ
		|	Товары КАК Закуп");
		Запрос.УстановитьПараметр("УстановкаЦенНоменклатуры", УстановкаЦенНоменклатуры);
		Запрос.УстановитьПараметр("ДатаСреза",                УстановкаЦенНоменклатуры.Дата - 1);
		Запрос.УстановитьПараметр("ВидыЦен",                  ВидыЦен);
		Запрос.УстановитьПараметр("Розница",Справочники.ххх_Справочник.РозничнаяЦена.Значение.Ссылка);
		Запрос.УстановитьПараметр("Закуп",Справочники.ххх_Справочник.ЗакупочнаяЦена.Значение.Ссылка);
		Запрос.УстановитьПараметр("Все",                      Не ПараметрыПечати.ПечататьТолькоИзмененныеЦены);
		Запрос.УстановитьПараметр("ТипШтрихкода",             Перечисления.ТипыШтрихкодов.EAN13);
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		
		Шапка = РезультатЗапроса[0].Выбрать();
		Шапка.Следующий();
		
		Если ПараметрыПечати.ВыводитьШапку Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
			ОбластьМакета.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Установка цен номенклатуры'"));
			ОбластьМакета.Параметры.ТекстЗаголовка=ОбластьМакета.Параметры.ТекстЗаголовка+
				"            "+?(ТипЗнч(УстановкаЦенНоменклатуры.ДокументОснование)=Тип("ДокументСсылка.ПоступлениеТоваров"),
				УстановкаЦенНоменклатуры.ДокументОснование.Контрагент,"");
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// Шапка таблицы
		КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
		ВыводитьКоды = ?(ЗначениеЗаполнено(КолонкаКодов),Истина, Ложь);
		
		ШапкаНомера  = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьНомера");
		ШапкаКодов   = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьКодов");
		ШапкаТовар   = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьТовар");
		ШапкаВидЦены = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
		ШапкаУникальныеИдентификаторы = Макет.ПолучитьОбласть("ШапкаТаблицы|УникальныеИдентификаторы");
		
		ТабДокумент.Вывести(ШапкаНомера);
		Если ВыводитьКоды Тогда
			ШапкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов;
			ТабДокумент.Присоединить(ШапкаКодов);
		КонецЕсли;
		Если Не ПараметрыПечати.ВыводитьШапку Тогда
			ТабДокумент.Присоединить(ШапкаУникальныеИдентификаторы);
		КонецЕсли;
		ТабДокумент.Присоединить(ШапкаТовар);
		
		
		Табл = Новый ТаблицаЗначений;
		Табл.Колонки.Добавить("ВидЦены");
		Табл.Колонки.Добавить("МакетОбласти");
				
		ВыборкаПоВидамЦен = РезультатЗапроса[4].Выбрать();
		Пока ВыборкаПоВидамЦен.Следующий() Цикл
			
			Новая                          = Табл.Добавить();
			Новая.ВидЦены                  = ВыборкаПоВидамЦен.ВидЦены;
		
					
			ШапкаВидЦены       = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
			Новая.МакетОбласти = Макет.ПолучитьОбласть("Строка|ОбластьВидЦены" + ?(Не ПараметрыПечати.ВыводитьШапку,"УникальныйИдентификатор",""));
						
			ШапкаВидЦены.Параметры.ВидЦены = ВыборкаПоВидамЦен.ВидЦены;
			ТабДокумент.Присоединить(ШапкаВидЦены);
			
		КонецЦикла;		
		
		ОбластьНомера = Макет.ПолучитьОбласть("Строка|ОбластьНомера");
		ОбластьКодов  = Макет.ПолучитьОбласть("Строка|ОбластьКодов");
		ОбластьТовар  = Макет.ПолучитьОбласть("Строка|ОбластьТовар");
		ОбластьУникальныеИдентификаторы = Макет.ПолучитьОбласть("Строка|УникальныеИдентификаторы");
		
		НомерСтроки = 0;
		ВыборкаПоНоменклатуре = РезультатЗапроса[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоНоменклатуре.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ВыборкаПоНоменклатуре.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;
			
			ВыборкаПоХарактеристикам = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоХарактеристикам.Следующий() Цикл
			
				НомерСтроки = НомерСтроки + 1;
				
				ОбластьНомера.Параметры.НомерСтроки = НомерСтроки;
				ТабДокумент.Вывести(ОбластьНомера);
				Если ВыводитьКоды Тогда
					
					Если КолонкаКодов = "Артикул" Тогда
						ОбластьКодов.Параметры.Артикул = ВыборкаПоНоменклатуре.Артикул;
					Иначе
						ОбластьКодов.Параметры.Артикул = ВыборкаПоНоменклатуре.Код;
					КонецЕсли;
					
					ТабДокумент.Присоединить(ОбластьКодов);
					
				КонецЕсли;
				
				Если Не ПараметрыПечати.ВыводитьШапку Тогда
					ОбластьУникальныеИдентификаторы.Параметры.УникальныйИдентификаторНоменклатура   = ВыборкаПоХарактеристикам.Номенклатура.УникальныйИдентификатор();
					ОбластьУникальныеИдентификаторы.Параметры.УникальныйИдентификаторХарактеристика = ВыборкаПоХарактеристикам.Характеристика.УникальныйИдентификатор();
					ТабДокумент.Присоединить(ОбластьУникальныеИдентификаторы);
				КонецЕсли;
				
				ОбластьТовар.Параметры.Заполнить(ВыборкаПоХарактеристикам);
				ОбластьТовар.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоХарактеристикам.ПолноеНаименованиеНоменклатуры, ВыборкаПоХарактеристикам.ПолноеНаименованиеХарактеристики);
				ОбластьТовар.Параметры.Наценка=?(ВыборкаПоХарактеристикам.Наценка<=0,ВыборкаПоХарактеристикам.Наценка,".");
				ТабДокумент.Присоединить(ОбластьТовар);
				
				ВыборкаПоВидамЦен = ВыборкаПоХарактеристикам.Выбрать();
				Для Каждого СтрокаТЗ Из Табл Цикл
					

					ВыборкаПоВидамЦен.Сбросить();
					Если ВыборкаПоВидамЦен.НайтиСледующий(Новый Структура("ВидЦены", СтрокаТЗ.ВидЦены)) Тогда
						
						ОбластьВидЦены = СтрокаТЗ.МакетОбласти;
						ОбластьВидЦены.Параметры.Цена = ВыборкаПоВидамЦен.Цена;	
						//Zorius
						ОбластьВидЦены.Параметры.СтараяЦена = ВыборкаПоВидамЦен.СтараяЦена;	
						//Zorius

						Если Не ПараметрыПечати.ВыводитьШапку Тогда
							ОбластьВидЦены.Параметры.УникальныйИдентификаторЕдиницаИзмерения = ВыборкаПоВидамЦен.Упаковка.УникальныйИдентификатор();
						КонецЕсли;
						
					Иначе
						
						ОбластьВидЦены = СтрокаТЗ.МакетОбласти;
						ОбластьВидЦены.Параметры.Цена = "";
						ОбластьВидЦены.Параметры.СтараяЦена = "";	

						//Zorius

						//ОбластьВидЦены.Параметры.ЕдиницаИзмерения = Неопределено;
						//
						//Если Не ПараметрыПечати.ВыводитьШапку Тогда
						//	ОбластьВидЦены.Параметры.УникальныйИдентификаторЕдиницаИзмерения = Справочники.УпаковкиНоменклатуры.ПустаяСсылка().УникальныйИдентификатор();
						//КонецЕсли;
						//Zorius

					КонецЕсли;
					
					ТабДокумент.Присоединить(ОбластьВидЦены);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Если ПараметрыПечати.ВыводитьШапку Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
			ОбластьМакета.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Шапка.Ответственный);
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, УстановкаЦенНоменклатуры);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

&После("ДобавитьКомандыПечати")
Процедура КочетовДобавитьКомандыПечати(КомандыПечати)
	
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "УстановкаЦенНоменклатуры";
	КомандаПечати.Представление = НСтр("ru = 'Установка цен номенклатуры (Штрихкоды)'");
	КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиУстановкиЦенШтрихкоды";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 75;
	
	
	ДоступнаПечатьЭтикетокИЦенников = ПравоДоступа("Использование", Метаданные.Обработки.ПечатьЭтикетокИЦенников);
	
	Если ДоступнаПечатьЭтикетокИЦенников Тогда
		
		ПараметрыПечатиЦенников = УправлениеПечатьюРТ.СтруктураПараметровПечатиЦенниковИЭтикеток();
		ПараметрыПечатиЦенников.ИмяПроцедурыПодготовкиСтруктурыДанных = "УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикетокДляУстановкиЦен";
		ПараметрыПечатиЦенников.ИмяДокумента = "УстановкаЦенНоменклатуры";
		ПараметрыПечатиЦенников.УстановитьРежим = "ПечатьИзменившихсяЦенников";
		
		// Ценники
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "ЦенникиИзменившиеся";
		КомандаПечати.Представление = НСтр("ru = 'Ценники, только изменившиеся'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиЦенниковИЭтикеток";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЦенников);
		КомандаПечати.Порядок = 85;
				
	КонецЕсли;

КонецПроцедуры



#КонецЕсли
