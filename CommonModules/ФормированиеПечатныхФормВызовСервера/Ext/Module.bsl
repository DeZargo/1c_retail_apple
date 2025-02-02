﻿#Область ПрограммныйИнтерфейс

// Процедура выполняет проведение документов перед формированием печатной формы.
//
// Параметры:
//	МассивДокументов - Массив - Документы, которые необходимо провести.
//
// Возвращаемое значение:
//	Массив - Документы, которые провести не удалось.
//
Функция ПровестиДокументы(МассивДокументов) Экспорт
	
	МассивНепроведенныхДокументов = Новый Массив;
	
	Для Каждого ДокументСсылка Из МассивДокументов Цикл
		
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		
		ВыполненоУспешно = Ложь;
		Если ДокументОбъект.ПроверитьЗаполнение() Тогда
	
			Попытка
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				ВыполненоУспешно = Истина;
			Исключение
			КонецПопытки;
			
		КонецЕсли;
		
		Если Не ВыполненоУспешно Тогда
			МассивНепроведенныхДокументов.Добавить(ДокументСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивНепроведенныхДокументов;
	
КонецФункции

// Функция по массиву документов возвращает массив непроведенных документов.
//
// Параметры:
//	МассивДокументов - документы, которые необходимо проверить.
//
// Возвращаемое значение:
//	Массив непроведенных документов.
//
Функция ПолучитьМассивНепроведенныхДокументов(МассивДокументов) Экспорт

	Если МассивДокументов.Количество() > 0 Тогда

		Запрос = Новый Запрос(
		"
		|ВЫБРАТЬ
		|	Документ.Ссылка КАК Ссылка
		|ИЗ
		|	Документ." + МассивДокументов[0].Метаданные().Имя + " КАК Документ
		|ГДЕ
		|	Документ.Ссылка В (&МассивДокументов)
		|	И Не Документ.Проведен
		|");
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Иначе

		Результат = Новый Массив;

	КонецЕсли;

	Возврат Результат;

КонецФункции

//  Функция формирует сведения об указанном ЮрФизЛице. К сведениям относятся -
// наименование, адрес, номер телефона, банковские реквизиты.
//
// Параметры: 
//  ЮрФизЛицо   - организация или физическое лицо, о котором собираются сведения.
//  ДатаПериода - дата, на которую выбираются сведения о ЮрФизЛице.
//  ДляФизЛицаТолькоИнициалы - Для физ. лица выводить только инициалы имени и отчества.
//  БанковскийСчет - Банковский счет, если счет не основной.
//
// Возвращаемое значение:
//  Сведения - собранные сведения.
//
Функция СведенияОЮрФизЛице(ЮрФизЛицо, ДатаПериода, ДляФизЛицаТолькоИнициалы = Истина, Знач БанковскийСчет = Неопределено) Экспорт
	
	Возврат ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ЮрФизЛицо, ДатаПериода, ДляФизЛицаТолькоИнициалы, БанковскийСчет);
	
КонецФункции

// Функция возвращает информацию об ответственных лицах организации и их должностях.
Функция ОтветственныеЛицаОрганизаций(Организация, ДатаСреза, Исполнитель = Неопределено, ПолноеФИО = Ложь) Экспорт
	
	Возврат ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(Организация, ДатаСреза, Исполнитель);
	
КонецФункции
	
#КонецОбласти