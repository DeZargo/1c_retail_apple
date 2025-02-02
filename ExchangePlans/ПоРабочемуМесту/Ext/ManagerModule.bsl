﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;

	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;

	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, 
	|состоящую из отдельных информационных баз системы «1С:Предприятие» - узлов распределенной информационной базы, 
	|между которыми организована синхронизация конфигурации и данных. Главной особенностью распределенных информационных баз 
	|является передача изменений конфигурации в подчиненные узлы. Имеется возможность настраивать ограничения миграции данных.'");
	
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "http://its.1c.ru/db/metod81#content:4351:1";
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);

	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Настройки обмена для рабочего места'");

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника       = НСтр("ru = 'Настройки обмена для рабочего места'");
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза   = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
КонецПроцедуры

// Возвращает префикс кода настройки выполнения обмена данными;
// Длина префикса не должна превышать один символ;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 1 - префикс кода настройки выполнения обмена данными.
// 
Функция ПрефиксНастройкиОбменаДанными() Экспорт
	
	Возврат "М";
	
КонецФункции

// Определяет несколько вариантов настройки расписания выполнения обмена данными;
// Рекомендуется указывать не более 3 вариантов;
// Эти варианты должны быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  ВариантыНастройки - СписокЗначений - список расписаний обмена данными.
//
Функция ВариантыНастройкиРасписания() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	// Расписание №1
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание1 = Новый РасписаниеРегламентногоЗадания;
	Расписание1.ДниНедели                = ДниНедели;
	Расписание1.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание1.ПериодПовтораДней        = 1; // каждый день
	Расписание1.Месяцы                   = Месяцы;
	
	// Расписание №2
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание2 = Новый РасписаниеРегламентногоЗадания;
	Расписание2.ВремяНачала              = Дата('00010101080000');
	Расписание2.ВремяКонца               = Дата('00010101200000');
	Расписание2.ПериодПовтораВТечениеДня = 3600; // каждый час
	Расписание2.ПериодПовтораДней        = 1; // каждый день
	Расписание2.ДниНедели                = ДниНедели;
	Расписание2.Месяцы                   = Месяцы;
	
	// Расписание №3
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	
	Расписание3 = Новый РасписаниеРегламентногоЗадания;
	Расписание3.ДниНедели         = ДниНедели;
	Расписание3.ВремяНачала       = Дата('00010101020000');
	Расписание3.ПериодПовтораДней = 1; // каждый день
	Расписание3.Месяцы            = Месяцы;
	
	// Возвращаемое значение функции.
	ВариантыНастройки = Новый СписокЗначений;
	
	ВариантыНастройки.Добавить(Расписание1, НСтр("ru='Один раз в 15 минут, кроме субботы и воскресенья'"));
	ВариантыНастройки.Добавить(Расписание2, НСтр("ru='Каждый час с 8:00 до 20:00, ежедневно'"));
	ВариантыНастройки.Добавить(Расписание3, НСтр("ru='Каждую ночь в 2:00, кроме субботы и воскресенья'"));
	
	Возврат ВариантыНастройки;
КонецФункции

// Определяет версию платформы базы-приемника для создания СОМ-подключения;
// Возможные варианты возвращаемого значения: "V81"; "V82".
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 3 - версия платформы базы-приемника (V81; V82).
//
Функция ВерсияПлатформыИнформационнойБазы() Экспорт
	
	Возврат "V82";
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура производит запись в регистр обновленных параметров обмена между узлами.
//
Процедура ПриЗаписиТранспортаОбмена(Источник, Отказ) Экспорт
			
	Если Отказ
		ИЛИ ЗначениеЗаполнено(ПланыОбмена.ПоРабочемуМесту.ЭтотУзел().РабочееМесто) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник.Отбор.Узел.Значение) = Тип("ПланОбменаСсылка.ПоРабочемуМесту") 
		И Источник.Отбор.Узел.Значение <> ПланыОбмена.ПоМагазину.ЭтотУзел() Тогда
		
		Узел = Источник.Отбор.Узел.Значение;
		
		СтруктураПараметров = Новый Структура;
		ПараметрыТранспортаОбмена = ?(Источник.Количество() > 0, Источник[0], Неопределено);
		
		Если ПараметрыТранспортаОбмена <> Неопределено Тогда
			Для каждого Ресурс Из Источник.Метаданные().Ресурсы Цикл
				СтруктураПараметров.Вставить(Ресурс.Имя, ПараметрыТранспортаОбмена[Ресурс.Имя]);
			КонецЦикла;
		КонецЕсли;
		
		ЗаписатьТранспортОбменаПоРабочемуМесту(СтруктураПараметров ,Узел.Код);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает структуру настроек по коду узла обмена.
//
Функция ПолучитьСтруктуруСценарияОбмена(КодУзлаОбмена) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СценарииОбменаРабочихМест.EMAILМаксимальныйДопустимыйРазмерСообщения,
	|	СценарииОбменаРабочихМест.EMAILСжиматьФайлИсходящегоСообщения,
	|	СценарииОбменаРабочихМест.EMAILУчетнаяЗапись,
	|	СценарииОбменаРабочихМест.FILEКаталогОбменаИнформацией,
	|	СценарииОбменаРабочихМест.FILEСжиматьФайлИсходящегоСообщения,
	|	СценарииОбменаРабочихМест.FTPСжиматьФайлИсходящегоСообщения,
	|	СценарииОбменаРабочихМест.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения,
	|	СценарииОбменаРабочихМест.FTPСоединениеПароль,
	|	СценарииОбменаРабочихМест.FTPСоединениеПассивноеСоединение,
	|	СценарииОбменаРабочихМест.FTPСоединениеПользователь,
	|	СценарииОбменаРабочихМест.FTPСоединениеПорт,
	|	СценарииОбменаРабочихМест.FTPСоединениеПуть,
	|	СценарииОбменаРабочихМест.ВидТранспортаСообщенийОбменаПоУмолчанию,
	|	СценарииОбменаРабочихМест.ВыполнятьОбменВРежимеОтладки,
	|	СценарииОбменаРабочихМест.ИмяФайлаПротоколаОбмена,
	|	СценарииОбменаРабочихМест.ПарольАрхиваСообщенияОбмена
	|ИЗ
	|	РегистрСведений.СценарииОбменаРабочихМест КАК СценарииОбменаРабочихМест
	|ГДЕ
	|	СценарииОбменаРабочихМест.КодУзлаОбмена = &КодУзлаОбмена");
	Запрос.УстановитьПараметр("КодУзлаОбмена", КодУзлаОбмена);
	ТаблицаНастроек = Запрос.Выполнить().Выгрузить();
	СтруктураНастроек = Новый Структура;
	Если ТаблицаНастроек.Количество() > 0 Тогда
		Для каждого Колонка Из ТаблицаНастроек.Колонки Цикл
			СтруктураНастроек.Вставить(Колонка.Имя, ТаблицаНастроек[0][Колонка.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

Процедура ЗаписатьТранспортОбменаПоРабочемуМесту(СтруктураПараметров, КодУзлаОбмена = "") Экспорт
	
	НаборЗаписей = РегистрыСведений.СценарииОбменаРабочихМест.СоздатьНаборЗаписей();
	
	Если ЗначениеЗаполнено(КодУзлаОбмена) Тогда
		
		НаборЗаписей.Отбор.КодУзлаОбмена.Установить(КодУзлаОбмена);
		
	КонецЕсли;
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.КодУзлаОбмена = КодУзлаОбмена;
		
	Иначе
		
		ЗаписьНабора = НаборЗаписей[0];
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЗаписьНабора, СтруктураПараметров);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Процедура создает/обновляет настройки обмена (и настройки выполнения) в узле рабочего места.
//
Процедура ОбновитьСценарииОбменаУзла(Узел, КодУзлаОбмена) Экспорт
		
	Если НЕ Узел.Пустая() Тогда
		СтруктураНастроек = ПолучитьСтруктуруСценарияОбмена(КодУзлаОбмена);
		Если СтруктураНастроек.Количество() > 0 
			И СценарийОбменаНеЗадан(КодУзлаОбмена) Тогда
							
			СценарийОбмена = Справочники.СценарииОбменовДанными.СоздатьЭлемент();
			СценарийОбмена.УстановитьНовыйКод();
			СценарийОбмена.Наименование = НСтр("ru = 'Обмен с главным узлом'");
			
			НастройкаОбмена = СценарийОбмена.НастройкиОбмена.Добавить();
			НастройкаОбмена.УзелИнформационнойБазы = Узел;
			НастройкаОбмена.ВидТранспортаОбмена = СтруктураНастроек.ВидТранспортаСообщенийОбменаПоУмолчанию;
			НастройкаОбмена.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
			
			НастройкаОбмена = СценарийОбмена.НастройкиОбмена.Добавить();
			НастройкаОбмена.УзелИнформационнойБазы = Узел;
			НастройкаОбмена.ВидТранспортаОбмена = СтруктураНастроек.ВидТранспортаСообщенийОбменаПоУмолчанию;
			НастройкаОбмена.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
			
			СценарийОбмена.Записать();
			
			НаборЗаписей = РегистрыСведений.НастройкиТранспортаОбменаДанными.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Узел.Установить(Узел);
			НаборЗаписей.Прочитать();
			НаборЗаписей.Очистить();
			Запись = НаборЗаписей.Добавить();
			Запись.Узел = Узел;
			ЗаполнитьЗначенияСвойств(Запись, СтруктураНастроек);
			НаборЗаписей.Записать();
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СценарийОбменаНеЗадан(КодУзлаОбмена)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.ПоРабочемуМесту КАК ПоРабочемуМесту
	|		ПО СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = ПоРабочемуМесту.Ссылка
	|ГДЕ
	|	ПоРабочемуМесту.Код = &КодУзлаОбмена");
	Запрос.УстановитьПараметр("КодУзлаОбмена", КодУзлаОбмена);
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	
КонецФункции

// Процедура выполняется при обновлении информационной базы рабочего места.
//
Процедура ОбновитьСценарииОбмена() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено 
		И ТипЗнч(ПланыОбмена.ГлавныйУзел()) = Тип("ПланОбменаСсылка.ПоРабочемуМесту") Тогда
			
		ВыборкаУзлов = ПланыОбмена.ПоРабочемуМесту.Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			Если ВыборкаУзлов.Ссылка <> ПланыОбмена.ПоРабочемуМесту.ЭтотУзел() Тогда
				ОбновитьСценарииОбменаУзла(ВыборкаУзлов.Ссылка, ПланыОбмена.ПоРабочемуМесту.ЭтотУзел().Код);
			КонецЕсли;
		КонецЦикла;
		Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоРабочееМесто() Экспорт
	
	ПериферийныйУзел = Ложь;
	
	Если ОбменДаннымиСлужебный.ОбменДаннымиВключен("ПоРабочемуМесту", ПланыОбмена.ПоРабочемуМесту.ЭтотУзел()) 
		И ЗначениеЗаполнено(ПланыОбмена.ПоРабочемуМесту.ЭтотУзел().РабочееМесто) Тогда
		
		ПериферийныйУзел = Истина;
		
	Иначе
		
		ПериферийныйУзел = Ложь;
		
	КонецЕсли;
	
	Возврат ПериферийныйУзел;
	
КонецФункции

Функция ПередаватьДанныеПослеПробитияЧекаККМ() Экспорт
	
	ПередаватьДанные = Ложь;
	Если ПланыОбмена.ПоРабочемуМесту.ЭтоРабочееМесто()
		И ПланыОбмена.ПоРабочемуМесту.ЭтотУзел().ПередаватьДанныеПослеКаждогоПробитогоЧека Тогда
		
		ПередаватьДанные = Истина;
		
	КонецЕсли;	
	
	Возврат ПередаватьДанные;
	
КонецФункции

#КонецОбласти

#КонецЕсли