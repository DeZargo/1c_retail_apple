﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Основные процедуры и функции.

// Все методы доступные в API оперирует параметрами заданий. Возможность использования 
// конкретного параметра зависит от метода и, в некоторых случаях, значений других
// параметров. Подробнее об этом написано в описании конкретных методов.
//
// Описание параметров:
//   ОбластьДанных - Число - значение разделителя области данных задания. 
//    -1 для неразделенных заданий. При установленном разделении сеанса всегда 
//    используется значение сеанса.
//   Идентификатор - СправочникСсылка.ОчередьЗаданий,
//     СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор задания.
//   Использование - Булево - признак использования задания.
//   ЗапланированныйМоментЗапуска - Дата (ДатаВремя) -дата запланированного запуска
//    задания (в часовом поясе области данных).
//   СостояниеЗадания - ПеречислениеСсылка.СостоянияЗаданий - состояние задания очереди.
//   ЭксклюзивноеВыполнение - Булево - При установленном флаге задание будет выполнено 
//    даже при установленной блокировке начала сеансов в области данных. Так же если в
//    области есть задания с таким флагом сначала будут выполнены они.
//   Шаблон - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания, используется только
//     для разделенных заданий очереди.
//   ИмяМетода - Строка - Имя метода (или псевдоним) обработчика задания. Не используется
//    для заданий созданных по шаблону.
//    Могут использоваться только методы для которых зарегистрированы псевдонимы через
//    процедуру ПриОпределенииПсевдонимовОбработчиков общего модуля ОчередьЗаданийПереопределяемый.
//   Параметры - Массив - Параметры для передачи в обработчик задания.
//   Ключ  - Строка - ключ задания. В пределах одной области данных не допускается 
//    дублирование заданий с одинаковым ключом и именем метода.
//   ИнтервалПовтораПриАварийномЗавершении - Число - Время ожидания в секундах перед 
//     повторным запуском задания в случае его аварийного завершения. Отсчитывается от 
//     времени окончания неудачной попытки выполнения задания. Имеет смысл указывать только 
//     совместно с параметром КоличествоПовторовПриАварийномЗавершении. 
//   Расписание - РасписаниеРегламентногоЗадания - Расписание по которому следует 
//    выполнять задание. Если не указано - задание будет выполнено только один раз.
//   КоличествоПовторовПриАварийномЗавершении - Число - Количество попыток повторного 
//    выполнения задания в случае его аварийного завершения.

// Получает задания очереди по заданному отбору.
// Возможно получение неконсистентных данных.
//
// Параметры:
//  Отбор - Структура - значения, по которым требуется отбирать задания (объединяются по И). Возможные ключи структуры:
//            * ОбластьДанных - Число - область данных,
//            * ИмяМетода - Строка - имя метода,
//            * Идентификатор - УникальныйИдентификатор - идентификатор задания,
//            * СостояниеЗадания - ПеречислениеСсылка.СостоянияЗаданий - состояние задания,
//            * Ключ - Строка - ключ задания,
//            * Шаблон - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания,
//            * Использование - Булево - использование задания.
//        - Массив - содержит структуры со свойствами:
//            * ВидСравнения - ВидСравнения - допустимыми значениями являются:
//                ВидСравнения.Равно
//                ВидСравнения.НеРавно
//                ВидСравнения.ВСписке
//                ВидСравнения.НеВСписке
//            * Значение - Значение отбора, для видов сравнения ВСписке и НеВСписке - массив значений, для видов
//                сравнения  Равно / НеРавно - сами значения.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица найденных заданий. Колонки соответствуют параметрам заданий.
//
Функция ПолучитьЗадания(Знач Отбор) Экспорт
	
	ПроверитьПараметрыЗадания(Отбор, "Отбор");
	
	// Формирование таблицы с условиями отбора.
	ТаблицаУсловий = Новый ТаблицаЗначений;
	ТаблицаУсловий.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТаблицаУсловий.Колонки.Добавить("ВидСравнения", Новый ОписаниеТипов("ВидСравнения"));
	ТаблицаУсловий.Колонки.Добавить("Параметр", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТаблицаУсловий.Колонки.Добавить("Значение");
	
	ОписанияПараметров = ОчередьЗаданийСлужебныйПовтИсп.ПараметрыЗаданийОчереди();
	
	ПолучатьРазделенные = Истина;
	ПолучатьНеразделенные = Истина;
	
	Для каждого КлючИЗначение Из Отбор Цикл
		
		ОписаниеПараметра = ОписанияПараметров.Найти(ВРег(КлючИЗначение.Ключ), "ИмяВРег");
		
		Если ОписаниеПараметра.РазделениеДанных Тогда
			КонтрольРазделения = Истина;
		Иначе
			КонтрольРазделения = Ложь;
		КонецЕсли;
		
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Массив") Тогда
			Для Индекс = 0 По КлючИЗначение.Значение.ВГраница() Цикл
				ОписаниеОтбора = КлючИЗначение.Значение[Индекс];
				
				Условие = ТаблицаУсловий.Добавить();
				Условие.Поле = ОписаниеПараметра.Поле;
				Условие.ВидСравнения = ОписаниеОтбора.ВидСравнения;
				Условие.Параметр = ОписаниеПараметра.Имя + ФорматИндекса(Индекс);
				Условие.Значение = ОписаниеОтбора.Значение;
				
				Если КонтрольРазделения Тогда
					ОпределениеФильтраПоРазделенностиСправочников(
						ОписаниеОтбора.Значение,
						ОписаниеПараметра,
						ПолучатьРазделенные,
						ПолучатьНеразделенные);
				КонецЕсли;
				
			КонецЦикла;
		Иначе
			
			Условие = ТаблицаУсловий.Добавить();
			Условие.Поле = ОписаниеПараметра.Поле;
			Условие.ВидСравнения = ВидСравнения.Равно;
			Условие.Параметр = ОписаниеПараметра.Имя;
			Условие.Значение = КлючИЗначение.Значение;
			
			Если КонтрольРазделения Тогда
				ОпределениеФильтраПоРазделенностиСправочников(
					КлючИЗначение.Значение,
					ОписаниеПараметра,
					ПолучатьРазделенные,
					ПолучатьНеразделенные);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Подготовка запроса
	Запрос = Новый Запрос;
	
	РазделительЗаданийОбластейДанных = РаботаВМоделиСервиса.РазделительВспомогательныхДанных();
	
	СправочникиЗаданий = ОчередьЗаданийСлужебныйПовтИсп.ПолучитьСправочникиЗаданий();
	ТекстЗапроса = "";
	Для Каждого СправочникЗаданий Из СправочникиЗаданий Цикл
		
		Отказ = Ложь;
		ИмяСправочника = Метаданные.НайтиПоТипу(ТипЗнч(СправочникЗаданий)).ПолноеИмя();
		
		Если Не ПолучатьРазделенные Тогда
			
			Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() И РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяСправочника, РазделительЗаданийОбластейДанных) Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ПолучатьНеразделенные Тогда
			
			Если Не РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() ИЛИ Не РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяСправочника, РазделительЗаданийОбластейДанных) Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|"
			
		КонецЕсли;
		
		ПоляВыборки = ОчередьЗаданийСлужебныйПовтИсп.ПоляВыборкиОчередиЗаданий(ИмяСправочника);
		
		СтрокаУсловий = "";
		Если ТаблицаУсловий.Количество() > 0 Тогда
			
			ВидыСравнения = ОчередьЗаданийСлужебныйПовтИсп.ВидыСравненияОтбораЗаданий();
			
			Для Каждого Условие Из ТаблицаУсловий Цикл
				
				Если Условие.Поле = РазделительЗаданийОбластейДанных Тогда
					Если Не РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() ИЛИ Не РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяСправочника, РазделительЗаданийОбластейДанных) Тогда
						Отказ = Истина;
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(СтрокаУсловий) Тогда
					СтрокаУсловий = СтрокаУсловий + Символы.ПС + Символы.Таб + "И ";
				КонецЕсли;
				
				СтрокаУсловий = СтрокаУсловий + "Очередь." + Условие.Поле + " "
					+ ВидыСравнения.Получить(Условие.ВидСравнения) + " (&" + Условие.Параметр + ")";
				
				Запрос.УстановитьПараметр(Условие.Параметр, Условие.Значение);
			КонецЦикла;
			
		КонецЕсли;
		
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() И РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяСправочника, РаботаВМоделиСервиса.РазделительВспомогательныхДанных()) Тогда
			
			ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ВЫБРАТЬ
				|" + ПоляВыборки + ",
				|	ЕСТЬNULL(ЧасовыеПояса.Значение, """") КАК ЧасовойПояс
				|ИЗ
				|	%1 КАК Очередь ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
				|		ПО Очередь.ОбластьДанныхВспомогательныеДанные = ЧасовыеПояса.ОбластьДанныхВспомогательныеДанные",
				СправочникЗаданий.ПустаяСсылка().Метаданные().ПолноеИмя());
			
		Иначе
			
			ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ВЫБРАТЬ
				|" + ПоляВыборки + ",
				|	"""" КАК ЧасовойПояс
				|ИЗ
				|	%1 КАК Очередь",
				СправочникЗаданий.ПустаяСсылка().Метаданные().ПолноеИмя());
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(СтрокаУсловий) Тогда
			
			ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	" + СтрокаУсловий;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		ВызватьИсключение НСтр("ru = 'Некорректное значение отбора - не обнаружено на одного справочника, задания из которого подходили бы под условия в отборе.'");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	// Получение данных
	Если ТранзакцияАктивна() Тогда
		Результат = Запрос.Выполнить().Выгрузить();
	Иначе
		Результат = РаботаВМоделиСервиса.ВыполнитьЗапросВнеТранзакции(Запрос).Выгрузить();
	КонецЕсли;
	
	// Приведение результатов
	Результат.Колонки.Расписание.Имя = "РасписаниеХранилище";
	Результат.Колонки.Параметры.Имя = "ПараметрыХранилище";
	Результат.Колонки.Добавить("Расписание", Новый ОписаниеТипов("РасписаниеРегламентногоЗадания, Неопределено"));
	Результат.Колонки.Добавить("Параметры", Новый ОписаниеТипов("Массив"));
	
	Для каждого СтрокаЗадания Из Результат Цикл
		СтрокаЗадания.Расписание = СтрокаЗадания.РасписаниеХранилище.Получить();
		СтрокаЗадания.Параметры = СтрокаЗадания.ПараметрыХранилище.Получить();
		
		ЧасовойПоясОбласти = СтрокаЗадания.ЧасовойПояс;
		Если Не ЗначениеЗаполнено(ЧасовойПоясОбласти) Тогда
			ЧасовойПоясОбласти = Неопределено;
		КонецЕсли;
		
		СтрокаЗадания.ЗапланированныйМоментЗапуска = 
			МестноеВремя(СтрокаЗадания.ЗапланированныйМоментЗапуска, ЧасовойПоясОбласти);
	КонецЦикла;
	
	Результат.Колонки.Удалить("РасписаниеХранилище");
	Результат.Колонки.Удалить("ПараметрыХранилище");
	Результат.Колонки.Удалить("ЧасовойПояс");
	
	Возврат Результат;
	
КонецФункции

// Добавляет новое задание в очередь.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  ПараметрыЗадания - Структура - Параметры добавляемого задания, возможные ключи:
//   ОбластьДанных
//   Использование
//   ЗапланированныйМоментЗапуска
//   ЭксклюзивноеВыполнение.
//   ИмяМетода - обязательно для указания.
//   Параметры
//   Ключ
//   ИнтервалПовтораПриАварийномЗавершении.
//   Расписание
//   КоличествоПовторовПриАварийномЗавершении.
//
// Возвращаемое значение: 
//  СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - Идентификатор добавленного задания.
// 
Функция ДобавитьЗадание(ПараметрыЗадания) Экспорт
	
	ПроверитьПараметрыЗадания(ПараметрыЗадания, "Добавление");
	
	// Проверка имени метода
	Если НЕ ПараметрыЗадания.Свойство("ИмяМетода") Тогда
		ВызватьИсключение(НСтр("ru = 'Не задан обязательный параметр задания ИмяМетода'"));
	КонецЕсли;
	
	ПроверитьНаличиеРегистрацииОбработчикаЗадания(ПараметрыЗадания.ИмяМетода);
	
	// Проверка уникальности ключа.
	Если ПараметрыЗадания.Свойство("Ключ") И ЗначениеЗаполнено(ПараметрыЗадания.Ключ) Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("ИмяМетода", ПараметрыЗадания.ИмяМетода);
		Отбор.Вставить("Ключ", ПараметрыЗадания.Ключ);
		Отбор.Вставить("ОбластьДанных", ПараметрыЗадания.ОбластьДанных);
		Отбор.Вставить("СостояниеЗадания", Новый Массив);
		
		// Не учитывать завершенные.
		ОписаниеОтбора = Новый Структура;
		ОписаниеОтбора.Вставить("ВидСравнения", ВидСравнения.НеРавно);
		ОписаниеОтбора.Вставить("Значение", Перечисления.СостоянияЗаданий.Завершено);
		
		Отбор.СостояниеЗадания.Добавить(ОписаниеОтбора);
		
		Если ПолучитьЗадания(Отбор).Количество() > 0 Тогда
			ВызватьИсключение ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом();
		КонецЕсли;
	КонецЕсли;
	
	// Умолчания
	Если НЕ ПараметрыЗадания.Свойство("Использование") Тогда
		ПараметрыЗадания.Вставить("Использование", Истина);
	КонецЕсли;
	
	ПланируемыйМоментЗапуска = Неопределено;
	Если ПараметрыЗадания.Свойство("ЗапланированныйМоментЗапуска", ПланируемыйМоментЗапуска) Тогда
		
		СтандартнаяОбработка = Истина;
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
			
			МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
			МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриОпределенииЗапланированногоМоментаЗапуска(
				ПараметрыЗадания,
				ПланируемыйМоментЗапуска,
				СтандартнаяОбработка);
			
		КонецЕсли;
		
		Если СтандартнаяОбработка Тогда
			ПланируемыйМоментЗапуска = УниверсальноеВремя(ПланируемыйМоментЗапуска);
		КонецЕсли;
		
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ПланируемыйМоментЗапуска);
		
		УказанМоментЗапуска = Истина;
		
	Иначе
		
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяУниверсальнаяДата());
		УказанМоментЗапуска = Ложь;
		
	КонецЕсли;
	
	// Типы сохраняемые в хранилище значения.
	Если ПараметрыЗадания.Свойство("Параметры") Тогда
		ПараметрыЗадания.Вставить("Параметры", Новый ХранилищеЗначения(ПараметрыЗадания.Параметры));
	Иначе
		ПараметрыЗадания.Вставить("Параметры", Новый ХранилищеЗначения(Новый Массив));
	КонецЕсли;
	
	Если ПараметрыЗадания.Свойство("Расписание") 
		И ПараметрыЗадания.Расписание <> Неопределено Тогда
		
		ПараметрыЗадания.Вставить("Расписание", Новый ХранилищеЗначения(ПараметрыЗадания.Расписание));
	Иначе
		ПараметрыЗадания.Вставить("Расписание", Неопределено);
	КонецЕсли;
	
	// Формирование записи задания.
	
	СправочникДляЗадания = Справочники.ОчередьЗаданий;
	СтандартнаяОбработка = Истина;
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
		ПереопределенныйСправочник = МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриВыбореСправочникаДляЗадания(ПараметрыЗадания);
		Если ПереопределенныйСправочник <> Неопределено Тогда
			СправочникДляЗадания = ПереопределенныйСправочник;
		КонецЕсли;
	КонецЕсли;
	
	Задание = СправочникДляЗадания.СоздатьЭлемент();
	Для каждого ОписаниеПараметра Из ОчередьЗаданийСлужебныйПовтИсп.ПараметрыЗаданийОчереди() Цикл
		Если ПараметрыЗадания.Свойство(ОписаниеПараметра.Имя) Тогда
			Если ОписаниеПараметра.РазделениеДанных Тогда
				Если Не РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() ИЛИ Не РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(Задание.Метаданные(), РаботаВМоделиСервиса.РазделительВспомогательныхДанных()) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Задание[ОписаниеПараметра.Поле] = ПараметрыЗадания[ОписаниеПараметра.Имя];
		КонецЕсли;
	КонецЦикла;
	
	Если Задание.Использование
		И (УказанМоментЗапуска ИЛИ ПараметрыЗадания.Расписание = Неопределено) Тогда
			
		Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.Запланировано;
	Иначе
		Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.НеЗапланировано;
	КонецЕсли;
	
	СсылкаЗадания = СправочникДляЗадания.ПолучитьСсылку();
	Задание.УстановитьСсылкуНового(СсылкаЗадания);
	
	Если ТранзакцияАктивна() Тогда
		
		ЗаблокироватьДанныеДляРедактирования(СсылкаЗадания);
		// Блокировка будет автоматически снята при завершении транзакции.
	КонецЕсли;
	
	РаботаВМоделиСервиса.ЗаписатьВспомогательныеДанные(Задание);
	
	Возврат Задание.Ссылка;
	
КонецФункции

// Изменяет задание с указанным идентификатором.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  Идентификатор - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - Идентификатор задания
//  ПараметрыЗадания - Структура - Параметры, которые следует установить заданию, 
//   возможные ключи:
//   Использование
//   ЗапланированныйМоментЗапуска
//   ЭксклюзивноеВыполнение
//   ИмяМетода.
//   Параметры
//   Ключ
//   ИнтервалПовтораПриАварийномЗавершении.
//   Расписание
//   КоличествоПовторовПриАварийномЗавершении.
//   
//   В случае если задание создано на основе шаблона, могут быть указаны
//   только следующие ключи:
//		Использование,
//		ЗапланированныйМоментЗапуска,
//		ЭксклюзивноеВыполнение,
//		ИнтервалПовтораПриАварийномЗавершении,
//		Расписание,
//		КоличествоПовторовПриАварийномЗавершении.
// 
Процедура ИзменитьЗадание(Идентификатор, ПараметрыЗадания) Экспорт
	
	ПроверитьПараметрыЗадания(ПараметрыЗадания, "Изменение");
	
	Задание = ОписаниеЗаданияПоИдентификатору(Идентификатор);
	
	// Проверка попытки изменения задания другой области.
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных()
		И Задание.ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
		
		ВызватьИсключение(ПолучитьТекстИсключенияПолученияДанныхДругойОбласти());
	КонецЕсли;
	
	// Проверка попытки изменения параметров заданий с заданным шаблоном.
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() И РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(
				Идентификатор.Метаданные().ПолноеИмя(),
				РаботаВМоделиСервиса.РазделительВспомогательныхДанных()) Тогда
		Если ЗначениеЗаполнено(Задание.Шаблон) Тогда
			ОписанияПараметров = ОчередьЗаданийСлужебныйПовтИсп.ПараметрыЗаданийОчереди();
			Для каждого КлючИЗначение Из ПараметрыЗадания Цикл
				ОписаниеПараметра = ОписанияПараметров.Найти(ВРег(КлючИЗначение.Ключ), "ИмяВРег");
				Если Не ОписаниеПараметра.Шаблон Тогда
					ШаблонСообщения = НСтр("ru = 'Задание очереди с идентификатором %1 создано на основе шаблона.
						|Изменение параметра %2 заданий с установленным шаблоном запрещено.'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор, ОписаниеПараметра.Имя);
					ВызватьИсключение(ТекстСообщения);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка уникальности ключа.
	Если ПараметрыЗадания.Свойство("Ключ") И ЗначениеЗаполнено(ПараметрыЗадания.Ключ) Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("ИмяМетода", ПараметрыЗадания.ИмяМетода);
		Отбор.Вставить("Ключ", ПараметрыЗадания.Ключ);
		Отбор.Вставить("ОбластьДанных", Задание.ОбластьДанных);
		Отбор.Вставить("Идентификатор", Новый Массив);
		
		// Не учитывать само изменяемое.
		ОписаниеОтбора = Новый Структура;
		ОписаниеОтбора.Вставить("ВидСравнения", ВидСравнения.НеРавно);
		ОписаниеОтбора.Вставить("Значение", Идентификатор);
		
		Отбор.Идентификатор.Добавить(ОписаниеОтбора);
		
		Если ПолучитьЗадания(Отбор).Количество() > 0 Тогда
			ВызватьИсключение ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом();
		КонецЕсли;
	КонецЕсли;
	
	ЗапланированныйМоментЗапуска = Неопределено;
	Если ПараметрыЗадания.Свойство("ЗапланированныйМоментЗапуска", ЗапланированныйМоментЗапуска)
			И ЗначениеЗаполнено(ПараметрыЗадания.ЗапланированныйМоментЗапуска) Тогда
		
		СтандартнаяОбработка = Истина;
		Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
			
			МодульОчередьЗаданийСлужебныйРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданийСлужебныйРазделениеДанных");
			МодульОчередьЗаданийСлужебныйРазделениеДанных.ПриОпределенииЗапланированногоМоментаЗапуска(
				ПараметрыЗадания,
				ЗапланированныйМоментЗапуска,
				СтандартнаяОбработка);
			
		КонецЕсли;
		
		Если СтандартнаяОбработка Тогда
			ЗапланированныйМоментЗапуска = УниверсальноеВремя(ЗапланированныйМоментЗапуска);
		КонецЕсли;
		
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ЗапланированныйМоментЗапуска);
		
		УказанМоментЗапуска = Истина;
	Иначе
		УказанМоментЗапуска = Ложь;
	КонецЕсли;
	
	// Типы сохраняемые в хранилище значения.
	Если ПараметрыЗадания.Свойство("Параметры") Тогда
		ПараметрыЗадания.Вставить("Параметры", Новый ХранилищеЗначения(ПараметрыЗадания.Параметры));
	КонецЕсли;
	
	Если ПараметрыЗадания.Свойство("Расписание")
		И ПараметрыЗадания.Расписание <> Неопределено Тогда
		
		ПараметрыЗадания.Вставить("Расписание", Новый ХранилищеЗначения(ПараметрыЗадания.Расписание));
	КонецЕсли;
	
	// Перепланирование задания с расписанием.
	Если НЕ ПараметрыЗадания.Свойство("ЗапланированныйМоментЗапуска", ЗапланированныйМоментЗапуска)
		И ПараметрыЗадания.Свойство("Расписание") Тогда
		
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ЗапланированныйМоментЗапуска);
	КонецЕсли;
	
	// Блокировка записи задания
	ЗаблокироватьДанныеДляРедактирования(Идентификатор);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Идентификатор.Метаданные().ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Идентификатор);
		Блокировка.Заблокировать();
		
		// Формирование записи задания.
		
		Если Не ОбщегоНазначения.СсылкаСуществует(Идентификатор) Тогда
			ШаблонСообщения = НСтр("ru = 'Задание с идентификатором %1 к изменению не найдено. Область данных: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор, Задание.ОбластьДанных);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Задание = Идентификатор.ПолучитьОбъект();
		
		Для каждого ОписаниеПараметра Из ОчередьЗаданийСлужебныйПовтИсп.ПараметрыЗаданийОчереди() Цикл
			Если ПараметрыЗадания.Свойство(ОписаниеПараметра.Имя) Тогда
				Задание[ОписаниеПараметра.Поле] = ПараметрыЗадания[ОписаниеПараметра.Имя];
			КонецЕсли;
		КонецЦикла;
		
		Если Задание.Использование
			И (УказанМоментЗапуска 
			ИЛИ НЕ ПараметрыЗадания.Свойство("Расписание")
			ИЛИ ПараметрыЗадания.Расписание = Неопределено) Тогда
				
			Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.Запланировано;
		Иначе
			Задание.СостояниеЗадания = Перечисления.СостоянияЗаданий.НеЗапланировано;
		КонецЕсли;
		
		РаботаВМоделиСервиса.ЗаписатьВспомогательныеДанные(Задание);
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	Если НЕ ТранзакцияАктивна() Тогда // Иначе блокировка будет снята при завершении транзакции.
		РазблокироватьДанныеДляРедактирования(Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет задание из очереди заданий.
// Удаление заданий с установленным шаблоном запрещено.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  Идентификатор - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных, - Идентификатор задания.
// 
Процедура УдалитьЗадание(Идентификатор) Экспорт
	
	Задание = Идентификатор.ПолучитьОбъект();
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() И РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(
				Задание.Метаданные().ПолноеИмя(),
				РаботаВМоделиСервиса.РазделительВспомогательныхДанных()) Тогда
		Если ЗначениеЗаполнено(Задание.Шаблон) Тогда
			ШаблонСообщения = НСтр("ru = 'Задание очереди с идентификатором %1 создано на основе шаблона.
				|Удаление заданий с установленным шаблоном запрещено.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(Идентификатор);
	
	Задание.ОбменДанными.Загрузка = Истина;
	РаботаВМоделиСервиса.УдалитьВспомогательныеДанные(Задание);
	
	Если НЕ ТранзакцияАктивна() Тогда // Иначе блокировка снимется при завершении транзакции.
		РазблокироватьДанныеДляРедактирования(Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает шаблон задания очереди по имени предопределенного 
// регламентного задания из которого он создан.
//
// Параметры:
//  Имя - Строка - имя предопределенного
//   регламентного задания.
//
// Возвращаемое значение:
//  СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания.
//
Функция ШаблонПоИмени(Знач Имя) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ШаблоныЗаданийОчереди.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ШаблоныЗаданийОчереди КАК ШаблоныЗаданийОчереди
	|ГДЕ
	|	ШаблоныЗаданийОчереди.Имя = &Имя";
	Запрос.УстановитьПараметр("Имя", Имя);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ШаблонСообщения = НСтр("ru = 'Не найден шаблон задания с именем %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Имя);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

// Возвращает текст ошибки при попытке выполнить одновременно два задания с одним ключом.
//
// Возвращаемое значение:
//   Строка - текст исключения.
//
Функция ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Экспорт
	
	Возврат НСтр("ru = 'Дублирование заданий с одинаковым значения поля ''Ключ'' не допустимо.'");
	
КонецФункции

// Возвращает список шаблонов заданий очереди.
//
// Возвращаемое значение:
//  Массив - имена предопределенных неразделенных регламентных заданий, которые используются 
//           в качестве шаблонов для заданий очереди.
//
Функция ШаблоныЗаданийОчереди() Экспорт
	
	Шаблоны = Новый Массив;
	
	ИнтеграцияПодсистемБСП.ПриПолученииСпискаШаблонов(Шаблоны);
	ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов(Шаблоны);
	
	Возврат Шаблоны;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет переданную структуру параметров на соответствие требованиям
// подсистемы:
//  - состав ключей
//  - типы параметров.
//
// Параметры:
//  Параметры - Структура - параметры заданий.
//  Режим - Строка - режим в котором следует проверять параметры.
//   Допустимые значения:
//    Отбор - проверка параметров для отбора.
//    Добавление - проверка параметров для добавления.
//    Изменение - проверка параметров для изменения.
// 
Процедура ПроверитьПараметрыЗадания(Параметры, Режим)
	
	Если ТипЗнч(Параметры) <> Тип("Структура") Тогда
		ШаблонСообщения = НСтр("ru = 'Передан недопустимый тип набора параметров задания - %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ТипЗнч(Параметры));
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Отбор = Режим = "Отбор";
	
	ОписанияПараметров = ОчередьЗаданийСлужебныйПовтИсп.ПараметрыЗаданийОчереди();
	
	ВидыСравнения = ОчередьЗаданийСлужебныйПовтИсп.ВидыСравненияОтбораЗаданий();
	
	КлючиОписанияОтбора = Новый Массив;
	КлючиОписанияОтбора.Добавить("ВидСравнения");
	КлючиОписанияОтбора.Добавить("Значение");
	
	Для каждого КлючИЗначение Из Параметры Цикл
		ОписаниеПараметра = ОписанияПараметров.Найти(ВРег(КлючИЗначение.Ключ), "ИмяВРег");
		Если ОписаниеПараметра = Неопределено 
			ИЛИ НЕ ОписаниеПараметра[Режим] Тогда
			
			ШаблонСообщения = НСтр("ru = 'Передан недопустимый параметр задания - %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КлючИЗначение.Ключ);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		Если Отбор И ТипЗнч(КлючИЗначение.Значение) = Тип("Массив") Тогда
			// Массив описаний отбора
			Для каждого ОписаниеОтбора Из КлючИЗначение.Значение Цикл
				Если ТипЗнч(ОписаниеОтбора) <> Тип("Структура") Тогда
					ШаблонСообщения = НСтр("ru = 'Передан недопустимый тип %1 в коллекции описания отбора %2'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ТипЗнч(ОписаниеОтбора), КлючИЗначение.Ключ);
					ВызватьИсключение(ТекстСообщения);
				КонецЕсли;
				
				// Проверка ключей
				Для каждого ИмяКлюча Из КлючиОписанияОтбора Цикл
					Если НЕ ОписаниеОтбора.Свойство(ИмяКлюча) Тогда
						ШаблонСообщения = НСтр("ru = 'Передано недопустимое описание отбора в коллекции описания отбора %1.
							|Отсутствует свойство %2.'");
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КлючИЗначение.Ключ, ИмяКлюча);
						ВызватьИсключение(ТекстСообщения);
					КонецЕсли;
				КонецЦикла;
				
				// Проверка вида сравнения
				Если ВидыСравнения.Получить(ОписаниеОтбора.ВидСравнения) = Неопределено Тогда
					ШаблонСообщения = НСтр("ru = 'Передан недопустимый вид сравнения в описании отбора в коллекции описания отбора %1'");
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КлючИЗначение.Ключ);
					ВызватьИсключение(ТекстСообщения);
				КонецЕсли;
				
				// Проверка значения
				Если ОписаниеОтбора.ВидСравнения = ВидСравнения.ВСписке
					ИЛИ ОписаниеОтбора.ВидСравнения = ВидСравнения.НеВСписке Тогда
					
					Если ТипЗнч(ОписаниеОтбора.Значение) <> Тип("Массив") Тогда
						ШаблонСообщения = НСтр("ru = 'Передан недопустимый тип %1 в описании отбора в коллекции описания отбора %2.
							|Для вида сравнения %3 ожидается тип Массив.'");
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ТипЗнч(ОписаниеОтбора.Значение), КлючИЗначение.Ключ, ОписаниеОтбора.ВидСравнения);
						ВызватьИсключение(ТекстСообщения);
					КонецЕсли;
					
					Для каждого ЗначениеОтбора Из ОписаниеОтбора.Значение Цикл
						ПроверитьЗначениеНаСоответствиеОписаниюПараметра(ЗначениеОтбора, ОписаниеПараметра);
					КонецЦикла;
				Иначе
					ПроверитьЗначениеНаСоответствиеОписаниюПараметра(ОписаниеОтбора.Значение, ОписаниеПараметра);
				КонецЕсли;
			КонецЦикла;
		Иначе
			ПроверитьЗначениеНаСоответствиеОписаниюПараметра(КлючИЗначение.Значение, ОписаниеПараметра);
		КонецЕсли;
	КонецЦикла;
	
	// Область данных
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Параметры.Свойство("ОбластьДанных") Тогда
			Если Параметры.ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
				ВызватьИсключение(НСтр("ru = 'В данном сеансе недопустимо обращение к данным из другой области данных.'"));
			КонецЕсли;
		Иначе
			ОписаниеПараметра = ОписанияПараметров.Найти(ВРег("ОбластьДанных"), "ИмяВРег");
			Если ОписаниеПараметра[Режим] Тогда
				Параметры.Вставить("ОбластьДанных", РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// ЗапланированныйМоментЗапуска
	Если Параметры.Свойство("ЗапланированныйМоментЗапуска")
		И НЕ ЗначениеЗаполнено(Параметры.ЗапланированныйМоментЗапуска) Тогда
		
		ШаблонСообщения = НСтр("ru = 'Передано недопустимое значение %1 параметра задания %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, 
			Параметры.ЗапланированныйМоментЗапуска, 
			ОписанияПараметров.Найти(ВРег("ЗапланированныйМоментЗапуска"), "ИмяВРег").Имя);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗначениеНаСоответствиеОписаниюПараметра(Знач Значение, Знач ОписаниеПараметра)
	
	Если НЕ ОписаниеПараметра.Тип.СодержитТип(ТипЗнч(Значение)) Тогда
		ШаблонСообщения = НСтр("ru = 'Передан недопустимый тип %1 параметра задания %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ТипЗнч(Значение), ОписаниеПараметра.Имя);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция ФорматИндекса(Знач Индекс)
	
	Возврат Формат(Индекс, "ЧН=0; ЧГ=")
	
КонецФункции

Процедура ПроверитьНаличиеРегистрацииОбработчикаЗадания(Знач ИмяМетода)
	
	Если ОчередьЗаданийСлужебныйПовтИсп.СоответствиеИменМетодовПсевдонимам().Получить(ВРег(ИмяМетода)) = Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Не зарегистрирован псевдоним метода %1 для использования в качестве обработчика задания очереди.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяМетода);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеЗаданияПоИдентификатору(Знач Идентификатор)
	
	Если Не ЗначениеЗаполнено(Идентификатор) ИЛИ Не ОбщегоНазначения.СсылкаСуществует(Идентификатор) Тогда
		ШаблонСообщения = НСтр("ru = 'Передано недопустимое значение %1 параметра задания Идентификатор'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Задания = ПолучитьЗадания(Новый Структура("Идентификатор", Идентификатор));
	Если Задания.Количество() = 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Задание очереди с идентификатором %1 не найдено'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат Задания[0];
	
КонецФункции

// Возвращает текст ошибки при попытке получить перечень заданий другой области из сеанса с
// с установленными значениями разделителя.
//
// Возвращаемое значение:
//   Строка - текст исключения.
//
Функция ПолучитьТекстИсключенияПолученияДанныхДругойОбласти()
	
	Возврат НСтр("ru = 'В данном сеансе недопустимо обращение к данным из другой области данных.'");
	
КонецФункции

Процедура ОпределениеФильтраПоРазделенностиСправочников(Знач Значение, Знач ОписаниеПараметра, ПолучатьРазделенные, ПолучатьНеразделенные)
	
	ТипЗначения = ТипЗнч(Значение);
	МассивТиповЗначения = Новый Массив();
	МассивТиповЗначения.Добавить(ТипЗначения);
	ОписаниеТипов = Новый ОписаниеТипов(МассивТиповЗначения);
	ЗначениеПоУмолчанию = ОписаниеТипов.ПривестиЗначение(
		ОписаниеПараметра.ЗначениеДляНеразделенныхЗаданий);
	Если Значение = ЗначениеПоУмолчанию Тогда
		
		ПолучатьРазделенные = Ложь;
		
	Иначе
		
		ПолучатьНеразделенные = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
