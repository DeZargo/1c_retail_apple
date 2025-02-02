﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ТипСтруктура = Тип("Структура");

	ЭтотОбъект.Ежемесячно_ПоДням_ДниМесяца.Очистить();
	Для С=1 По 31 Цикл
		ЭтотОбъект.Ежемесячно_ПоДням_ДниМесяца.Добавить(С, С, Ложь);
	КонецЦикла;
	ЭтотОбъект.Ежемесячно_ПоДням_ДниМесяца.Добавить(32, "Последний", Ложь);

	ЭтотОбъект.Еженедельно_ДниНедели.Очистить();
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(1, НСтр("ru='Понедельник'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(2, НСтр("ru='Вторник'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(3, НСтр("ru='Среда'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(4, НСтр("ru='Четверг'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(5, НСтр("ru='Пятница'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(6, НСтр("ru='Суббота'"), Ложь);
	ЭтотОбъект.Еженедельно_ДниНедели.Добавить(7, НСтр("ru='Воскресенье'"), Ложь);

	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Очистить();
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(1, НСтр("ru='Понедельник'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(2, НСтр("ru='Вторник'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(3, НСтр("ru='Среда'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(4, НСтр("ru='Четверг'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(5, НСтр("ru='Пятница'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(6, НСтр("ru='Суббота'"), Ложь);
	ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.Добавить(7, НСтр("ru='Воскресенье'"), Ложь);

	Если ТипЗнч(Параметры.РасписаниеАвтоматическогоРезервногоКопирования) = ТипСтруктура Тогда

		// Обязательные поля:
		//  ** РасписаниеВключено - Булево;
		//  ** Вариант - Строка - "Ежедневно_ОдинРазВДень", "Ежедневно_НесколькоРазВДень", "Еженедельно",
		//               "Ежемесячно_ПоДням", "Ежемесячно_ПоДнямНедели".
		//               Возможно добавление варианта "Однократно" перед остальными вариантами.
		//  ** Ежедневно_ОдинРазВДень:
		//    *** Время (Время);
		//  ** Ежедневно_НесколькоРазВДень:
		//    *** ВремяНачала (Время);
		//    *** ВремяОкончания (Время);
		//    *** КоличествоЧасовПовтора (Число 1..23);
		//  ** Еженедельно:
		//    *** Время (Время);
		//    *** ДниНедели (Массив (числа 1..7));
		//  ** Ежемесячно_ПоДням:
		//    *** Время (Время);
		//    *** ДниМесяца (Массив (числа 1..32));
		//  ** Ежемесячно_ПоДнямНедели:
		//    *** Время (Время);
		//    *** НомерНедели (Число 1..5) (first, second, third, fourth, last);
		//    *** ДниНедели (Массив (числа 1..7)).

		лкРасписание = ПровестиВалидациюНастроекНаСервере(Параметры.РасписаниеАвтоматическогоРезервногоКопирования);

		ЭтотОбъект.Вариант = лкРасписание.Вариант;

		Если ЭтотОбъект.Вариант = "Ежедневно_ОдинРазВДень" Тогда
			ЭтотОбъект.Ежедневно_ОдинРазВДень_Время = лкРасписание.Ежедневно_ОдинРазВДень.Время;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
		ИначеЕсли ЭтотОбъект.Вариант = "Ежедневно_НесколькоРазВДень" Тогда
			ЭтотОбъект.Ежедневно_НесколькоРазВДень_ВремяНачала            = лкРасписание.Ежедневно_НесколькоРазВДень.ВремяНачала;
			ЭтотОбъект.Ежедневно_НесколькоРазВДень_ВремяОкончания         = лкРасписание.Ежедневно_НесколькоРазВДень.ВремяОкончания;
			ЭтотОбъект.Ежедневно_НесколькоРазВДень_КоличествоЧасовПовтора = лкРасписание.Ежедневно_НесколькоРазВДень.КоличествоЧасовПовтора;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
		ИначеЕсли ЭтотОбъект.Вариант = "Еженедельно" Тогда
			ЭтотОбъект.Еженедельно_Время = лкРасписание.Еженедельно.Время;
			Для Каждого ТекущийЭлементМассива Из лкРасписание.Еженедельно.ДниНедели Цикл
				НайденнаяСтрока = ЭтотОбъект.Еженедельно_ДниНедели.НайтиПоЗначению(ТекущийЭлементМассива);
				Если НайденнаяСтрока <> Неопределено Тогда
					НайденнаяСтрока.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
		ИначеЕсли ЭтотОбъект.Вариант = "Ежемесячно_ПоДням" Тогда
			ЭтотОбъект.Ежемесячно_ПоДням_Время = лкРасписание.Ежемесячно_ПоДням.Время;
			Для Каждого ТекущийЭлементМассива Из лкРасписание.Ежемесячно_ПоДням.ДниМесяца Цикл
				НайденнаяСтрока = ЭтотОбъект.Ежемесячно_ПоДням_ДниМесяца.НайтиПоЗначению(ТекущийЭлементМассива);
				Если НайденнаяСтрока <> Неопределено Тогда
					НайденнаяСтрока.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
		ИначеЕсли ЭтотОбъект.Вариант = "Ежемесячно_ПоДнямНедели" Тогда
			ЭтотОбъект.Ежемесячно_ПоДнямНедели_Время = лкРасписание.Ежемесячно_ПоДнямНедели.Время;
			ЭтотОбъект.Ежемесячно_ПоДнямНедели_НомерНедели = лкРасписание.Ежемесячно_ПоДнямНедели.НомерНедели;
			Для Каждого ТекущийЭлементМассива Из лкРасписание.Ежемесячно_ПоДнямНедели.ДниНедели Цикл
				НайденнаяСтрока = ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели.НайтиПоЗначению(ТекущийЭлементМассива);
				Если НайденнаяСтрока <> Неопределено Тогда
					НайденнаяСтрока.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Ежедневно_ОдинРазВДень_ВремяПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежедневно_НесколькоРазВДень_ВремяНачалаПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежедневно_НесколькоРазВДень_ВремяОкончанияПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежедневно_НесколькоРазВДень_КоличествоЧасовПовтораПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Еженедельно_ВремяПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Еженедельно_ДниНеделиПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежемесячно_ПоДням_ВремяПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежемесячно_ПоДням_ДниМесяцаПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежемесячно_ПоДнямНедели_ВремяПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежемесячно_ПоДнямНедели_НомерНеделиПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура Ежемесячно_ПоДнямНедели_ДниНеделиПриИзменении(Элемент)

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)

	Если ЭтотОбъект.Вариант = "Ежедневно_ОдинРазВДень" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
	ИначеЕсли ЭтотОбъект.Вариант = "Ежедневно_НесколькоРазВДень" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
	ИначеЕсли ЭтотОбъект.Вариант = "Еженедельно" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
	ИначеЕсли ЭтотОбъект.Вариант = "Ежемесячно_ПоДням" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
	ИначеЕсли ЭтотОбъект.Вариант = "Ежемесячно_ПоДнямНедели" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["Страница" + ЭтотОбъект.Вариант];
	КонецЕсли;

	лкРасписание = СформироватьРезультат();
	ЭтотОбъект.РасписаниеТекстом = ОблачныйАрхивКлиентСервер.ПолучитьТекстовоеОписаниеРасписания(лкРасписание, "Подробно");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)

	Если ПустаяСтрока(ЭтотОбъект.Вариант) Тогда
		ПоказатьОповещениеПользователя(
			,
			,
			НСтр("ru='Расписание не было настроено'"),
			БиблиотекаКартинок.ИнтернетПоддержкаВнимание);
		ЭтотОбъект.Закрыть(Неопределено);
	Иначе
		Результат = СформироватьРезультат();
		Результат = ПровестиВалидациюНастроекНаСервере(Результат);
		ОповеститьОВыборе(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)

	ЭтотОбъект.Закрыть(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Правильно заполняет структуру настроек расписания.
//
// Параметры:
//  Результат - Структура - структура настроек.
//
// Возвращаемое значение:
//   Структура - структура с правильными ключами, как настроено в ХранилищеНастроек.НастройкиОблачногоАрхива.
//
&НаСервереБезКонтекста
Функция ПровестиВалидациюНастроекНаСервере(Результат)

	Результат = ХранилищаНастроек.НастройкиОблачногоАрхива.ПровестиВалидациюНастроек(Результат, "РасписаниеАвтоматическогоРезервногоКопирования", "");

	Возврат Результат;

КонецФункции

// Формирует структуру расписания для сохранения в хранилище настроек.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Структура   - Структура расписания.
//
&НаКлиенте
Функция СформироватьРезультат()

	// В Агенте резервного копирования необходимо передавать даты в GMT.
	// Функция УниверсальноеВремя('00010101121314') вернет другое значение  смещения, чем УниверсальноеВремя('20160527121314'),
	//  поэтому все время необходимо привести к текущей дате.

	Результат = Новый Структура();
	Результат.Вставить("РасписаниеВключено", Истина); // Если сумели открыть эту форму, значит расписание было включено.
	Результат.Вставить("Вариант", ЭтотОбъект.Вариант);
	Результат.Вставить("Ежедневно_ОдинРазВДень",
		Новый Структура("Время",
			ПривестиКТекущейДате(ЭтотОбъект.Ежедневно_ОдинРазВДень_Время)));
	Результат.Вставить("Ежедневно_НесколькоРазВДень",
		Новый Структура("ВремяНачала,ВремяОкончания,КоличествоЧасовПовтора",
			ПривестиКТекущейДате(ЭтотОбъект.Ежедневно_НесколькоРазВДень_ВремяНачала),
			ПривестиКТекущейДате(ЭтотОбъект.Ежедневно_НесколькоРазВДень_ВремяОкончания),
			ЭтотОбъект.Ежедневно_НесколькоРазВДень_КоличествоЧасовПовтора));
	Результат.Вставить("Еженедельно",
		Новый Структура("Время, ДниНедели",
			ПривестиКТекущейДате(ЭтотОбъект.Еженедельно_Время),
			ИнтернетПоддержкаПользователейКлиент.ОтмеченныеЭлементыСпискаЗначений(ЭтотОбъект.Еженедельно_ДниНедели, Истина)));
	Результат.Вставить("Ежемесячно_ПоДням",
		Новый Структура("Время, ДниМесяца",
			ПривестиКТекущейДате(ЭтотОбъект.Ежемесячно_ПоДням_Время),
			ИнтернетПоддержкаПользователейКлиент.ОтмеченныеЭлементыСпискаЗначений(ЭтотОбъект.Ежемесячно_ПоДням_ДниМесяца, Истина)));
	Результат.Вставить("Ежемесячно_ПоДнямНедели",
		Новый Структура("Время, НомерНедели, ДниНедели",
			ПривестиКТекущейДате(ЭтотОбъект.Ежемесячно_ПоДнямНедели_Время),
			ЭтотОбъект.Ежемесячно_ПоДнямНедели_НомерНедели,
			ИнтернетПоддержкаПользователейКлиент.ОтмеченныеЭлементыСпискаЗначений(ЭтотОбъект.Ежемесячно_ПоДнямНедели_ДниНедели, Истина)));

	Возврат Результат;

КонецФункции

// Функция меняет параметр таким образом, что время остается как есть, а дата подставляется текущая.
//
// Параметры:
//  Дата - Дата - дата, которую необходимо преобразовать.
//
// Возвращаемое значение:
//   Дата - преобразованная дата.
//
&НаКлиенте
Функция ПривестиКТекущейДате(Дата)

	лкТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();

	Результат = Дата(
		Год(лкТекущаяДата),
		Месяц(лкТекущаяДата),
		День(лкТекущаяДата),
		Час(Дата),
		Минута(Дата),
		Секунда(Дата));

	Возврат Результат;

КонецФункции

#КонецОбласти
