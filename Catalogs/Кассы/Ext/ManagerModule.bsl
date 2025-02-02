﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает организацию и магазин к которой принадлежит операционная касса.
//
// Параметры:
//  Касса - СправочникСсылка.Кассы - Ссылка на кассу.
//
// Возвращаемое значение:
//	Структура - Организация, Магазин к которой принадлежит операционная касса.
//
Функция РеквизитыКассы(Касса) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Кассы.Владелец КАК Организация,
	|	Кассы.Магазин  КАК Магазин
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Ссылка = &Касса
	|");
	
	Запрос.УстановитьПараметр("Касса", Касса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
		Магазин     = Выборка.Магазин;
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
		Магазин     = Справочники.Магазины.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Организация, Магазин", Организация, Магазин);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Возвращает кассу по умолчанию для магазина в разрезе организации.
// Касса по умолчанию - это одна операционная касса магазина по организации.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Ссылка на организацию.
//  Магазин - СправочникСсылка.Магазины - Ссылка на магазин.
//
// Возвращаемое значение:
//	СправочникСсылка.Кассы- Касса по умолчанию.
//
Функция КассаПоУмолчанию(Организация, Знач Магазин = Неопределено) Экспорт
	Перем КассаПоУмолчанию;
	КассаПоУмолчанию = Справочники.Кассы.ПустаяСсылка();
	Если НЕ ЗначениеЗаполнено(Магазин) Тогда
		Магазин = ПараметрыСеанса.ТекущийМагазин;
	КонецЕсли;
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Кассы.Ссылка КАК Касса
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|" + ?(ЗначениеЗаполнено(Магазин), " И Кассы.Магазин = &Магазин", "") + "
	|	И НЕ Кассы.ПометкаУдаления
	|	И НЕ Кассы.КассаУправляющейСистемы
	|";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1.00 Тогда
			Выборка.Следующий();
			КассаПоУмолчанию = Выборка.Касса;
		КонецЕсли;
	КонецЕсли;
	Возврат КассаПоУмолчанию;
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Владелец");
	Результат.Добавить("Магазин");
	Результат.Добавить("ПробиватьЧекиПоКассеККМ");
	Результат.Добавить("КассаККМ");
	Результат.Добавить("ШаблонПКО");
	Результат.Добавить("ШаблонРКО");
	
	Возврат Результат;
КонецФункции

// Процедура заполняет массивы реквизитов, зависимых от реквизита КассаУправляющейСистемы.
// Параметры:
//           Объект - СправочникСсылка.Кассы или ДинамическийСписок- Элемент справочника для которого устанавливаем
//                    доступные реквизиты.
//           МассивВсехРеквизитов - Неопределено - Выходной параметр с типом Массив в который будут помещены имена всех
//                                                 реквизитов справочника.
//           МассивРеквизитовОперации - Неопределено - Выходной параметр с типом Массив в который будут помещены имена
//                                                     реквизитов справочника.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Объект, МассивВсехРеквизитов, МассивВидимыхРеквизитов, ДополнительныеСкрываемыеЭлементы = Неопределено) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	Если ДополнительныеСкрываемыеЭлементы = Неопределено Тогда
		ДополнительныеСкрываемыеЭлементы = Новый Структура("Организация");
	КонецЕсли;
	
	МассивВидимыхРеквизитов = Новый Массив;
	Если ТипЗнч(Объект) = Тип("ДинамическийСписок") Тогда
		// Процедура вызвана для формы списка.
		МассивВсехРеквизитов.Добавить("Магазин");
		МассивВсехРеквизитов.Добавить("Организация");
		МассивВсехРеквизитов.Добавить("ОтборМагазин");
		МассивВсехРеквизитов.Добавить("ОтборОрганизация");
		МассивВсехРеквизитов.Добавить("Владелец");
		МассивВидимыхРеквизитов.Добавить("Магазин");
		МассивВидимыхРеквизитов.Добавить("ОтборМагазин");
	
		Для Каждого СкрываемоеПоле Из ДополнительныеСкрываемыеЭлементы Цикл
			Если МассивВидимыхРеквизитов.Найти(СкрываемоеПоле.Ключ) <> Неопределено Тогда
				МассивВидимыхРеквизитов.Удалить(МассивВидимыхРеквизитов.Найти(СкрываемоеПоле.Ключ));
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Процедура вызвана для формы элемента.
		МассивВсехРеквизитов.Добавить("Магазин");
		МассивВсехРеквизитов.Добавить("ШаблонРКО");
		МассивВсехРеквизитов.Добавить("ШаблонПКО");
		МассивВсехРеквизитов.Добавить("ПробиватьЧекиПоКассеККМ");
		МассивВсехРеквизитов.Добавить("КассаККМ");
		Если НЕ Объект.КассаУправляющейСистемы Тогда
			МассивВидимыхРеквизитов.Добавить("Магазин");
			МассивВидимыхРеквизитов.Добавить("ШаблонРКО");
			МассивВидимыхРеквизитов.Добавить("ШаблонПКО");
			МассивВидимыхРеквизитов.Добавить("ПробиватьЧекиПоКассеККМ");
			МассивВидимыхРеквизитов.Добавить("КассаККМ");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазин)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли
