﻿
процедура сформировать()экспорт
	ТабличныйДокумент.Очистить();
	
	Запрос=Новый запрос;
	запрос.УстановитьПараметр("ДатаНачала",Период.ДатаНачала);
	запрос.УстановитьПараметр("ДатаКонца",Период.ДатаОкончания);
	запрос.УстановитьПараметр("ххх_ИдЦентр","460");
	запрос.УстановитьПараметр("АналитикаХозОперСписаниеПоРезультатамРевизии",Справочники.ххх_Справочник.АналитикаХозОперСписаниеПоРезультатамРевизии.Значение);
	Запрос.Текст="ВЫБРАТЬ
	             |	СписаниеТоваров.Ссылка КАК Ссылка,
	             |	СписаниеТоваров.СуммаДокумента КАК СуммаДокумента,
	             |	СписаниеТоваров.АналитикаХозяйственнойОперации.Наименование КАК АналитикаХозяйственнойОперацииНаименование,
	             |	NULL КАК Контрагент,
	             |	NULL КАК НомерВходящегоДокумента
	             |ПОМЕСТИТЬ йцу
	             |ИЗ
	             |	Документ.СписаниеТоваров КАК СписаниеТоваров
	             |ГДЕ
	             |	СписаниеТоваров.Проведен
	             |	И СписаниеТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаКонца
	             |	И СписаниеТоваров.АналитикаХозяйственнойОперации <> &АналитикаХозОперСписаниеПоРезультатамРевизии
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	ПоступлениеТоваров.Ссылка,
	             |	ПоступлениеТоваров.СуммаДокумента,
	             |	NULL,
	             |	ПоступлениеТоваров.Контрагент,
	             |	ПоступлениеТоваров.НомерВходящегоДокумента
	             |ИЗ
	             |	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
	             |ГДЕ
	             |	ПоступлениеТоваров.Контрагент.ххх_Поставщик
	             |	И ПоступлениеТоваров.Контрагент.ххх_ИдЦентр = &ххх_ИдЦентр
	             |	И ПоступлениеТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаКонца
	             |	И ПоступлениеТоваров.Проведен
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	йцу.Ссылка КАК Ссылка,
	             |	йцу.СуммаДокумента КАК СуммаДокумента,
	             |	йцу.АналитикаХозяйственнойОперацииНаименование КАК АналитикаХозяйственнойОперацииНаименование,
	             |	йцу.Ссылка.Дата КАК СсылкаДата,
	             |	йцу.Ссылка.Комментарий КАК СсылкаКомментарий,
	             |	йцу.Контрагент.Наименование КАК КонтрагентНаименование,
	             |	йцу.НомерВходящегоДокумента КАК НомерВходящегоДокумента
	             |ИЗ
	             |	йцу КАК йцу
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	АналитикаХозяйственнойОперацииНаименование";
	//Выгрузка=запрос.Выполнить().Выгрузить();
	Выборка=Запрос.Выполнить().Выбрать();
	//Для каждого стр из Выгрузка Цикл
	//	стр.НастройкиКомпоновкиДанных=ххх_Сервер.ОписаниеПараметровНастройки(стр.скд, стр.НастройкиКомпоновкиДанных);
	//КонецЦикла
	
	Макет=ЭтотОбъект.ПолучитьМакет("Макет");
	
	
	Шапка=макет.ПолучитьОбласть("Шапка");
	Шапка.параметры.магазин=?(Выборка.Следующий(),Выборка.Ссылка.Магазин,"");
	ТабличныйДокумент.Вывести(Шапка);

	ШапкаТаблицы=макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ШапкаТаблицы);

	Выборка.Сбросить();
	
	Пока Выборка.Следующий() Цикл
		
		Строка=макет.ПолучитьОбласть("Строка");
		Строка.параметры.Номер=Выборка.ссылка.Номер;
		Строка.параметры.Дата=Выборка.ссылка.Дата;
		Строка.параметры.Документ=ТипЗнч(Выборка.ссылка);
		Строка.параметры.ВхНомер=Выборка.НомерВходящегоДокумента;
		Строка.параметры.ХозОпер=Выборка.АналитикаХозяйственнойОперацииНаименование;
		Строка.параметры.Сумма=Выборка.ссылка.СуммаДокумента;
		Строка.параметры.Комментарий=Выборка.ссылка.Комментарий;
		ТабличныйДокумент.Вывести(Строка);
		
	КонецЦикла;
	
	
	Подвал=Макет.ПолучитьОбласть("Подвал");
	
	ТабличныйДокумент.Вывести(Подвал);
	
КонецПРоцедуры
	





















