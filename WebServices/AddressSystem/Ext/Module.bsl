﻿#Область СлужебныеПроцедурыИФункции

// Метод Ping (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     Locale - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
//
Функция Ping(Locale, ConfigurationName)
	
	Данные = Новый Структура("Данные");
	АдресныйКлассификаторСлужебный.ЗаполнитьВерсиюПоставщикаДанныхВнутр(Данные);
	
	Возврат Данные.Данные;
КонецФункции

// Метод GetActualInfo (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     ID     - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор запрашиваемого адресного объекта.
//     Locale - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
// 
// Возвращаемое значение:
//     АдресРФ (http://www.v8.1c.ru/ssl/contactinfo) - XML адреса РФ.
//
Функция GetActualInfo(ID, Locale, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные");
	АдресныйКлассификаторСлужебный.ЗаполнитьАктуальныеАдресныеСведенияВнутр(СтруктураОбработки, ID);
	
	Возврат СтруктураОбработки.Данные;
КонецФункции

// Метод GetExtraInfo (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     ID     - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор запрашиваемого адресного объекта.
//     Locale - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
// 
// Возвращаемое значение:
//     ExtraInfo (http://www.v8.1c.ru/ssl/AddressSystem)
//
Функция GetExtraInfo(ID, Locale, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные", АдресныйКлассификаторСлужебный.СтруктураДополнительныхАдресныхСведений() );
	АдресныйКлассификаторСлужебный.ЗаполнитьДополнительныеАдресныеСведенияВнутр(СтруктураОбработки, ID);
	
	Результат = ФабрикаXDTO.Создать( АдресныйКлассификаторСлужебный.ПространствоИмен(), "ExtraInfo");
	Данные = СтруктураОбработки.Данные;
	
	Результат.OKATO      = Данные.OKATO;
	Результат.OKTMO      = Данные.ОКТМО;
	Результат.IFNSFL     = Данные.КодИФНСФЛ;
	Результат.IFNSUL     = Данные.КодИФНСЮЛ;
	Результат.TERRIFNSFL = Данные.КодУчасткаИФНСФЛ;
	Результат.TERRIFNSUL = Данные.КодУчасткаИФНСЮЛ;
	
	Возврат Результат;
КонецФункции

// Метод Autocomplete (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Поиск производится как по полному совпадению (с учетом сокращений), так и по частичному.
//
// Параметры:
//     Parent - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор родительского объекта, может быть пуст.
//     Text   - Строка - Набранный пользователем текст.
//     Levels - Levels (http://www.v8.1c.ru/ssl/AddressSystem) - Список используемых уровней.
//     Limit  - Число  - Ограничение размера порции возвращаемой порции.
//     Locale - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
//
// Возвращаемое значение:
//     PresentationList (http://www.v8.1c.ru/ssl/AddressSystem)  - список вариантов.
//
Функция Autocomplete(Parent, Levels, Text, Limit, Locale, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные", АдресныйКлассификаторСлужебный.ТаблицаДанныхАвтоподбора() );
	
	ДополнительныеПараметры = Новый Структура;
	АдресныйКлассификаторСлужебный.ЗаполнитьСписокАвтоподбораЧастиАдресаВнутр(СтруктураОбработки, Text, Parent, Levels, ДополнительныеПараметры);

	Результат = СписокПредставлений(СтруктураОбработки.Данные, Неопределено, Неопределено, Неопределено, Неопределено);
	
	Возврат Результат;
КонецФункции

// Метод Select (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     Parent - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор родительского объекта, может быть пуст.
//     Level  - Число  - Требуемый уровень классификатора.
//     Base   - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор объекта, с которого начинается порция
//              данных сам объект не должен входить в выборку.
//     Sort   - SortDirection (http://www.v8.1c.ru/ssl/AddressSystem) 
//            - Строка - Режим. Определяет порядок сортировки по наименованию.
//     Limit  - Число - Размер порции возвращаемых порции.
//     Locale - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
//
// Возвращаемое значение:
//     PresentationList (http://www.v8.1c.ru/ssl/AddressSystem) - список вариантов.
//
Функция Select(Parent, Level, Base, Sort, Limit, Locale, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные", АдресныйКлассификаторСлужебный.ТаблицаДанныхДляИнтерактивногоВыбора() );
	
	ДополнительныеПараметры = Новый Структура;
	Уровни                  = АдресныйКлассификаторПовтИсп.УровниКлассификатораФИАС();
	
	АдресныйКлассификаторСлужебный.ЗаполнитьАдресаДляИнтерактивногоВыбораВнутр(СтруктураОбработки, Уровни, Parent, Level, ДополнительныеПараметры);	
	
	// Только порция нужного размера.
	Результат = СписокПредставлений(СтруктураОбработки.Данные, Неопределено, Base, Sort, Limit);
	
	Возврат Результат;
КонецФункции

// Метод SelectByPostalCode (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     PostalCode - Число - Почтовый индекс.
//     Levels     - Levels (http://www.v8.1c.ru/ssl/AddressSystem) - Список используемых уровней.
//     Base       - UUID (http://www.v8.1c.ru/ssl/AddressSystem) - Идентификатор объекта, с которого начинается порция
//                  данных.
//     Sort       - SortDirection (http://www.v8.1c.ru/ssl/AddressSystem) 
//                - Строка - Режим. Определяет порядок сортировки по наименованию сам объект не должен входить в
//                выборку.
//     Limit      - Число - Размер порции возвращаемых порции.
//     Locale     - Строка - код языка, на котором ожидается результат и сообщения об ошибках.
//
// Возвращаемое значение:
//     PresentationList (http://www.v8.1c.ru/ssl/AddressSystem) - список вариантов.
//
Функция SelectByPostalCode(PostalCode, Levels, Base, Sort, Limit, Locale, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные, ОбщаяЧастьПредставления", АдресныйКлассификаторСлужебный.ТаблицаДанныхДляВыбораПоПочтовомуИндексу() );
	
	ДополнительныеПараметры = Новый Структура;
	
	АдресныйКлассификаторСлужебный.ЗаполнитьАдресаПоПочтовомуИндексуКлассификатораВнутр(СтруктураОбработки, PostalCode, Levels, ДополнительныеПараметры);
	
	// Только порция нужного размера.
	Результат = СписокПредставлений(СтруктураОбработки.Данные, СтруктураОбработки.ОбщаяЧастьПредставления, Base, Sort, Limit);
	
	Возврат Результат;
КонецФункции

// Метод Analyze (http://www.v8.1c.ru/ssl/AddressSystem)
//
// Параметры:
//     Values - AddressList (http://www.v8.1c.ru/ssl/AddressSystem) - список адресов и уровней для проверки.
//     Locale - Строка - код локализации для сообщениях об ошибке.
//
// Возвращаемое значение:
//     AddressAnalysisResult (http://www.v8.1c.ru/ssl/AddressSystem) - результат анализа.
//
Функция Analyze(Values, Locale, CheckAsKladr, ConfigurationName)
	
	СтруктураОбработки = Новый Структура("Данные", Новый Массив);
	
	АдресаДляПроверки = Новый Массив;
	Для Каждого АдресПроверки Из Values.ПолучитьСписок("Item") Цикл
		АдресаДляПроверки.Добавить(Новый Структура("Адрес, Уровни", АдресПроверки.Address, АдресПроверки.Levels));
	КонецЦикла;
	
	АдресныйКлассификаторСлужебный.ЗаполнитьРезультатПроверкиАдресаПоКлассификаторуВнутр(СтруктураОбработки, АдресаДляПроверки);
	
	Результат = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(АдресныйКлассификаторСлужебный.ПространствоИмен(), "AddressAnalysisResult"));
	ТипЭлементаПроверки = Результат.Свойства().Получить("Item").Тип;
	ТипОшибкаАдреса  = ТипЭлементаПроверки.Свойства.Получить("Error").Тип;
	ТипВариантАдреса = ТипЭлементаПроверки.Свойства.Получить("Variant").Тип;
	
	Для Каждого РезультатПроверки Из СтруктураОбработки.Данные Цикл
		ЭлементПроверки =  Результат.Item.Добавить( ФабрикаXDTO.Создать(ТипЭлементаПроверки));
	
		Для Каждого Ошибка Из РезультатПроверки.Ошибки Цикл
			ОшибкаАдреса = ЭлементПроверки.Error.Добавить(ФабрикаXDTO.Создать(ТипОшибкаАдреса));
			ОшибкаАдреса.Key        = Ошибка.Ключ;
			ОшибкаАдреса.Text       = Ошибка.Текст;
			ОшибкаАдреса.Suggestion = Ошибка.Подсказка;
		КонецЦикла;
		
		Для Каждого Вариант Из РезультатПроверки.Варианты Цикл
			ОшибкаАдреса = ЭлементПроверки.Variant.Добавить(ФабрикаXDTO.Создать(ТипВариантАдреса));
			ОшибкаАдреса.ID         = Ошибка.Идентификатор;
			ОшибкаАдреса.PostalCode = Ошибка.Индекс;
			ОшибкаАдреса.KLADRCode  = Ошибка.КодКЛАДР;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Генерирует Presentation List по части таблицы.
//
Функция СписокПредставлений(Таблица, Заголовок, ОсновнойЭлемент, Направление, РазмерПорции)
	
	ТипСписка   = ФабрикаXDTO.Тип( АдресныйКлассификаторСлужебный.ПространствоИмен(), "PresentationList");
	Результат   = ФабрикаXDTO.Создать(ТипСписка);
	Список      = Результат.ПолучитьСписок("Item");
	ТипЭлемента = Список.ВладеющееСвойство.Тип;
	
	ОбщееЧислоСтрок = Таблица.Количество();
	
	Если Направление = "DESC" Тогда
		Шаг    = -1;
		Предел = -1;
	Иначе
		Шаг    = 1;
		Предел = ОбщееЧислоСтрок;
	КонецЕсли;
	
	Индекс = 0;
	Если ЗначениеЗаполнено(ОсновнойЭлемент) Тогда
		СтрокаОсновного = Таблица.Найти(Новый УникальныйИдентификатор(ОсновнойЭлемент), "Идентификатор");
		Если СтрокаОсновного <> Неопределено Тогда
			Индекс = Таблица.Индекс(СтрокаОсновного) + Шаг;
		КонецЕсли;
	КонецЕсли;
	
	Порция = ?(ЗначениеЗаполнено(РазмерПорции), РазмерПорции, ОбщееЧислоСтрок);
	
	Пока Индекс <> Предел Цикл
		СтрокаТаблицы = Таблица[Индекс];
		
		Элемент = ФабрикаXDTO.Создать(ТипЭлемента);
		Элемент.ID           = СтрокаТаблицы.Идентификатор;
		Элемент.Presentation = СтрокаТаблицы.Представление;
		Список.Добавить(Элемент);
		
		Индекс = Индекс + Шаг;
		
		Порция = Порция - 1;
		Если Порция = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Заголовок <> Неопределено Тогда
		Результат.Title = Заголовок;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти
