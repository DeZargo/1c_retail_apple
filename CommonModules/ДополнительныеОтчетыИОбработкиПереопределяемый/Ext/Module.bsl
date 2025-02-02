﻿#Область ПрограммныйИнтерфейс

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
// В Разделы необходимо добавить метаданные тех разделов,
// в которых размещены команды вызова.
// 
// Для рабочего стола вместо Метаданных необходимо добавлять
// ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных обработок.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.ЗапасыИЗакупки);
	Разделы.Добавить(Метаданные.Подсистемы.Склад);
	Разделы.Добавить(Метаданные.Подсистемы.Маркетинг);
	Разделы.Добавить(Метаданные.Подсистемы.НормативноСправочнаяИнформация);
	Разделы.Добавить(Метаданные.Подсистемы.Органайзер);
	Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	Разделы.Добавить(Метаданные.Подсистемы.Финансы);
	Разделы.Добавить(Метаданные.Подсистемы.Персонал);
	
	// Администрирование
	Если Разделы.Найти(Метаданные.Подсистемы.Администрирование) = Неопределено Тогда
		Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	КонецЕсли;
	// Конец Администрирование
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
// В Разделы необходимо добавить метаданные тех разделов, 
// в которых размещены команды вызова.
// 
// Для рабочего стола вместо Метаданных необходимо добавлять
// ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола().
//
// Параметры:
//   Разделы - Массив - Разделы, в которых размещены команды вызова дополнительных отчетов.
//       * ОбъектМетаданных: Подсистема - Метаданные раздела (подсистемы).
//       * Строка - Для рабочего стола.
//
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.ЗапасыИЗакупки);
	Разделы.Добавить(Метаданные.Подсистемы.Склад);
	Разделы.Добавить(Метаданные.Подсистемы.Маркетинг);
	Разделы.Добавить(Метаданные.Подсистемы.НормативноСправочнаяИнформация);
	Разделы.Добавить(Метаданные.Подсистемы.Органайзер);
	Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	Разделы.Добавить(Метаданные.Подсистемы.Финансы);
	Разделы.Добавить(Метаданные.Подсистемы.Персонал);
	
	// Администрирование
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	// Конец Администрирование
	
КонецПроцедуры

#КонецОбласти
