﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру, содержащую различные персональные настройки.
Функция ПерсональныеНастройкиРаботыСФайлами() Экспорт
	
	ПерсональныеНастройки =
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПерсональныеНастройкиРаботыСФайлами;
	
	// Проверка и обновление настроек сохраненных на сервере,
	// которые вычисляются на клиенте.
	
	Возврат ПерсональныеНастройки;
	
КонецФункции

// Возвращает структуру, содержащую различные персональные настройки.
Функция ОбщиеНастройкиРаботыСФайлами() Экспорт
	
	ОбщиеНастройки = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ОбщиеНастройкиРаботыСФайлами;
	
	// Проверка и обновление настроек сохраненных на сервере,
	// которые вычисляются на клиенте.
	
	Возврат ОбщиеНастройки;
	
КонецФункции

// Возвращает параметр сеанса ПутьКРабочемуКаталогуПользователя.
Функция РабочийКаталогПользователя() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Ложь);
	КонецЕсли;
	
	ИмяКаталога =
		СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПерсональныеНастройкиРаботыСФайлами.ПутьКЛокальномуКэшуФайлов;
	
	// Уже установлен.
	Если ИмяКаталога <> Неопределено
		И НЕ ПустаяСтрока(ИмяКаталога)
		И ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] Тогда
		
		Возврат ИмяКаталога;
	КонецЕсли;
	
	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		Если НЕ ПустаяСтрока(ИмяКаталога) Тогда
			ФайловыеФункцииСлужебныйКлиент.УстановитьРабочийКаталогПользователя(ИмяКаталога);
		Иначе
			ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
			Возврат ""; // Веб клиент без расширения работы с файлами.
		КонецЕсли;
	КонецЕсли;
	
#Если НЕ ВебКлиент Тогда
	
	// Создать каталог для файлов.
	Попытка
		СоздатьКаталог(ИмяКаталога);
		ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		// Нет прав на создание каталога, или такой путь отсутствует,
		// тогда установка настроек по умолчанию.
		ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя();
		ФайловыеФункцииСлужебныйКлиент.УстановитьРабочийКаталогПользователя(ИмяКаталога);
	КонецПопытки;
	
#КонецЕсли
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПроверкаДоступаКРабочемуКаталогуВыполнена"] = Истина;
	
	Возврат ИмяКаталога;
	
КонецФункции

#КонецОбласти
