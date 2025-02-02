﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Магазины.Ссылка
		|ИЗ
		|	Справочник.Магазины КАК Магазины
		|ГДЕ
		|	НЕ Магазины.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() < 2 Тогда
		Элементы.Поставщик.ВыбиратьТип = Ложь;
		Элементы.Поставщик.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокРаспоряжений", "СписокРаспоряженийДата");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин = Настройки.Получить("Магазин");
	Склад   = Настройки.Получить("Склад");
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ПриходныйОрдерНаТовары.Форма.ФормаСписка.Открытие");

	УстановитьДоступностьСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокРаспоряженийНаПриемкуТоваров" Тогда
		ЗаполнитьСписокРаспоряжений();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Документ.ПриходныйОрдерНаТовары.Форма.ФормаДокумента.Открытие");
               
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Склад");
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРаспоряженияНаПриемку Тогда
		ЗаполнитьСписокРаспоряжений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьВсеОтборыДинамическогоСписка();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРаспоряженияНаПриемку Тогда
		ЗаполнитьСписокРаспоряжений();
	КонецЕсли;

	УстановитьДоступностьСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	
	ЗаполнитьСписокРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриемкиПриИзменении(Элемент)
	
	ЗаполнитьСписокРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВыполненныеРаспоряженияПриИзменении(Элемент)
	ЗаполнитьСписокРаспоряжений();
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьПросроченныеПоставкиПриИзменении(Элемент)
	ЗаполнитьСписокРаспоряжений();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаРаспоряженияНаПриемку Тогда
		ЗаполнитьСписокРаспоряжений();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиСписокРаспоряжений

&НаКлиенте
Процедура СписокРаспоряженийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокРаспоряжений.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ПоказатьЗначение(,ТекущиеДанные.Распоряжение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьСписокРаспоряжений();
	
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВсеОтборыДинамическогоСписка()
	
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список,
		ИмяРеквизита,
		ЭтаФорма[ИмяРеквизита],
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()

	СписокРаспоряжений.Очистить();
	
	Запрос = Новый Запрос; 
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Склады.Ссылка КАК Склад
		|ПОМЕСТИТЬ СкладыМагазина
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Магазин = &Магазин
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТоварыКПоступлениюОбороты.ДокументОснование КАК ДокументРаспоряжение,
		|	ВЫБОР
		|		КОГДА ТоварыКПоступлениюОбороты.ДокументОснование ССЫЛКА Документ.ЗаказПоставщику
		|			ТОГДА ВЫБОР
		|					КОГДА НЕ ТоварыКПоступлениюОбороты.ДокументОснование.Закрыт
		|							И НЕ ТоварыКПоступлениюОбороты.ДокументОснование.Бессрочный
		|							И ДОБАВИТЬКДАТЕ(ТоварыКПоступлениюОбороты.ДокументОснование.ДатаПоступления, ДЕНЬ, ТоварыКПоступлениюОбороты.ДокументОснование.ДнейПросрочкиПоставки) < &ТекущаяДатаСеанса
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПросроченаПоставка
		|ПОМЕСТИТЬ Распоряжения
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Регистратор,
		|			ВЫБОР
		|					КОГДА &ОтборПоСкладу
		|						ТОГДА Склад = &Склад
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ
		|				И ВЫБОР
		|					КОГДА &ОтборПоМагазину
		|						ТОГДА Склад В
		|								(ВЫБРАТЬ
		|									СкладыМагазина.Склад
		|								ИЗ
		|									СкладыМагазина КАК СкладыМагазина)
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ) КАК ТоварыКПоступлениюОбороты
		|ГДЕ
		|	НЕ ТоварыКПоступлениюОбороты.Регистратор ССЫЛКА Документ.ПриходныйОрдерНаТовары
		|	И ВЫБОР
		|			КОГДА &ОтборПоМагазину
		|				ТОГДА ЕСТЬNULL(ТоварыКПоступлениюОбороты.ДокументОснование.Магазин, ТоварыКПоступлениюОбороты.ДокументОснование.МагазинПолучатель) = &Магазин
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка,
		|	ВЫБОР
		|		КОГДА НЕ ЗаказПоставщику.Закрыт
		|				И НЕ ЗаказПоставщику.Бессрочный
		|				И ДОБАВИТЬКДАТЕ(ЗаказПоставщику.ДатаПоступления, ДЕНЬ, ЗаказПоставщику.ДнейПросрочкиПоставки) < &ТекущаяДатаСеанса
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.Проведен
		|	И (ЗаказПоставщику.Бессрочный
		|			ИЛИ НЕ ЗаказПоставщику.ДнейПросрочкиПоставки = 0)
		|	И ВЫБОР
		|			КОГДА НЕ ЗаказПоставщику.Бессрочный
		|				ТОГДА ЗаказПоставщику.ДатаПоступления МЕЖДУ &НачалоПериода И &КонецПериода
		|						ИЛИ ДОБАВИТЬКДАТЕ(ЗаказПоставщику.ДатаПоступления, ДЕНЬ, ЗаказПоставщику.ДнейПросрочкиПоставки) МЕЖДУ &НачалоПериода И &КонецПериода
		|						ИЛИ ЗаказПоставщику.ДатаПоступления <= &НачалоПериода
		|							И ДОБАВИТЬКДАТЕ(ЗаказПоставщику.ДатаПоступления, ДЕНЬ, ЗаказПоставщику.ДнейПросрочкиПоставки) >= &КонецПериода
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ОтборПоСкладу
		|				ТОГДА ЗаказПоставщику.Склад = &Склад
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ОтборПоМагазину
		|				ТОГДА ЗаказПоставщику.Магазин = &Магазин
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ДокументРаспоряжение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ТоварыКПоступлениюОстаткиИОбороты.ДокументОснование.ДатаПоступления, ТоварыКПоступлениюОстаткиИОбороты.ДокументОснование.Дата) КАК Дата,
		|	ТоварыКПоступлениюОстаткиИОбороты.ДокументОснование КАК Распоряжение,
		|	ЕСТЬNULL(ТоварыКПоступлениюОстаткиИОбороты.ДокументОснование.Контрагент, ТоварыКПоступлениюОстаткиИОбороты.ДокументОснование.МагазинОтправитель) КАК Поставщик,
		|	ТоварыКПоступлениюОстаткиИОбороты.Номенклатура КАК Номенклатура,
		|	ТоварыКПоступлениюОстаткиИОбороты.Характеристика КАК Характеристика,
		|	ТоварыКПоступлениюОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
		|	ТоварыКПоступлениюОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
		|	ВЫБОР
		|		КОГДА ТоварыКПоступлениюОстаткиИОбороты.КоличествоКонечныйОстаток > 0
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выполнен
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.ОстаткиИОбороты(
		|			,
		|			,
		|			,
		|			,
		|			ДокументОснование В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					Распоряжения.ДокументРаспоряжение
		|				ИЗ
		|					Распоряжения КАК Распоряжения)) КАК ТоварыКПоступлениюОстаткиИОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура,
		|	Характеристика,
		|	Поставщик
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.Дата КАК Дата,
		|	ВложенныйЗапрос.Распоряжение,
		|	ВложенныйЗапрос.Поставщик,
		|	ВложенныйЗапрос.Выполнен,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Выполнен
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ВложенныйЗапросРаспоряжения.ПросроченаПоставка
		|	КОНЕЦ КАК ПросроченаПоставка
		|ПОМЕСТИТЬ ИтоговыйРезультат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Результат.Дата КАК Дата,
		|		Результат.Распоряжение КАК Распоряжение,
		|		Результат.Поставщик КАК Поставщик,
		|		ВЫБОР
		|			КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Результат.Выполнен) = 1
		|				ТОГДА МАКСИМУМ(Результат.Выполнен)
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ КАК Выполнен
		|	ИЗ
		|		Результат КАК Результат
		|	ГДЕ
		|		ВЫБОР
		|				КОГДА &ОтборПоПоставщику
		|					ТОГДА Результат.Поставщик = &Поставщик
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Результат.Дата,
		|		Результат.Поставщик,
		|		Результат.Распоряжение) КАК ВложенныйЗапрос
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			Распоряжения.ДокументРаспоряжение КАК ДокументРаспоряжение,
		|			Распоряжения.ПросроченаПоставка КАК ПросроченаПоставка
		|		ИЗ
		|			Распоряжения КАК Распоряжения) КАК ВложенныйЗапросРаспоряжения
		|		ПО ВложенныйЗапрос.Распоряжение = ВложенныйЗапросРаспоряжения.ДокументРаспоряжение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИтоговыйРезультат.Дата,
		|	ИтоговыйРезультат.Распоряжение,
		|	ИтоговыйРезультат.Поставщик,
		|	ИтоговыйРезультат.Выполнен,
		|	ИтоговыйРезультат.ПросроченаПоставка
		|ИЗ
		|	ИтоговыйРезультат КАК ИтоговыйРезультат
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &ОтборПоСтатусу
		|				ТОГДА ИтоговыйРезультат.Выполнен = ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА &ОтборПоСтатусуПросрочки
		|				ТОГДА ИтоговыйРезультат.ПросроченаПоставка = ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИтоговыйРезультат.Дата";
	
	Запрос.УстановитьПараметр("ОтборПоПоставщику", ЗначениеЗаполнено(Поставщик));
	Запрос.УстановитьПараметр("ОтборПоСтатусу", НЕ ОтображатьВыполненныеРаспоряжения);
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	Запрос.УстановитьПараметр("ОтборПоСкладу", ЗначениеЗаполнено(Склад));
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ОтборПоМагазину", ЗначениеЗаполнено(Магазин));
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ОтборПоСтатусуПросрочки", НЕ ОтображатьПросроченныеПоставки);
	
	Запрос.УстановитьПараметр("НачалоПериода", ПериодПриемки.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",  ПериодПриемки.ДатаОкончания);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		СписокРаспоряжений.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСклада()

	Элементы.ОтборСклад.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Магазин);

КонецПроцедуры

#КонецОбласти
