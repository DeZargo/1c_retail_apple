﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ТипНоменклатуры; ТипНоменклатуры");
	
	Результат.Добавить("ИспользованиеХарактеристик");
	Результат.Добавить("ИспользоватьХарактеристики");
	
	Результат.Добавить("ИспользоватьСерии; ИспользоватьСерии");
	Результат.Добавить("ПолитикиУчетаСерий");
	Результат.Добавить("НастройкаИспользованияСерий; НастройкаИспользованияСерий");
	Результат.Добавить("АгентскиеУслуги");
	Результат.Добавить("ВидАлкогольнойПродукцииЕГАИС");
	Результат.Добавить("ИмпортнаяАлкогольнаяПродукция");
	
	Результат.Добавить("ШаблонЦенника");
	Результат.Добавить("ШаблонЭтикетки");
	Результат.Добавить("НаборУпаковок");
	Результат.Добавить("СтавкаНДС");
	Результат.Добавить("ЦеноваяГруппа");
	Результат.Добавить("ТоварнаяГруппа");
	Результат.Добавить("ЕдиницаИзмерения");
	
	Результат.Добавить("СтранаПроисхождения");
	Результат.Добавить("Производитель");
	Результат.Добавить("Марка");
	Результат.Добавить("ТипСрокаДействия");
	Результат.Добавить("ТоварнаяКатегория");
	Результат.Добавить("ВидМехаГИСМ");
	Результат.Добавить("КодТНВЭД");
	Результат.Добавить("ИзменитьТипНоменклатуры; ИзменитьТипНоменклатуры");

	Результат.Добавить("ПравилоИменования");
	Результат.Добавить("ЗапретитьРедактированиеНаименования");
	
	Возврат Результат;

КонецФункции

// Получает вид номенклатуры, если вид номенклатуры один в справочнике.
//
// Возвращаемое значение:
// СправочникСсылка.ВидНоменклатуры - Найденный вид номенклатуры
// Неопределено - если видов номенклатуры нет или видов номенклатуры больше одного.
//
Функция ПолучитьВидНоменклатурыПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	НЕ ВидыНоменклатуры.ПометкаУдаления
	|");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ВидНоменклатуры = Выборка.ВидНоменклатуры;
	Иначе
		ВидНоменклатуры = Неопределено;
	КонецЕсли;
	
	Возврат ВидНоменклатуры;

КонецФункции // ВидНоменклатуры()

// Получает набор свойств характеристик для вида номенклатуры.
//
// Возвращаемое значение:
// СправочникСсылка.ВидНоменклатуры - Найденный вид номенклатуры
// Неопределено - если видов номенклатуры нет или видов номенклатуры больше одного.
//
Функция ПолучитьНаборСвойствХарактеристик(ВидНоменклатуры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыНоменклатуры.НаборСвойствХарактеристик КАК НаборСвойствХарактеристик
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.Ссылка = &Ссылка
	|");
	
	Запрос.Параметры.Вставить("Ссылка", ВидНоменклатуры);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		НаборСвойствХарактеристик = Выборка.НаборСвойствХарактеристик;
	КонецЕсли;
	
	Возврат НаборСвойствХарактеристик;

КонецФункции // ПолучитьНаборСвойствХарактеристик()

// Получает набор свойств для вида номенклатуры.
//
// Возвращаемое значение:
// СправочникСсылка.ВидНоменклатуры - Найденный вид номенклатуры
// Неопределено - если видов номенклатуры нет или видов номенклатуры больше одного.
//
Функция ПолучитьНаборСвойств(ВидНоменклатуры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыНоменклатуры.НаборСвойств КАК НаборСвойств
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.Ссылка = &Ссылка
	|");
	
	Запрос.Параметры.Вставить("Ссылка", ВидНоменклатуры);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		НаборСвойств = Выборка.НаборСвойств;
	КонецЕсли;
	
	Возврат НаборСвойств;

КонецФункции // ПолучитьНаборСвойств()

// Возвращает структуру с параметрами учетной политики по сериям.
// Параметры:
//		ВидНоменклатуры - вид номенклатуры для которого нужно получить параметры учетной политики по сериям.
Функция ПараметрыСерийНоменклатуры(ВидНоменклатуры) Экспорт
	
	СтруктураВозврата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидНоменклатуры, "ИспользоватьНомерСерии,
																			|ИспользоватьСрокГодностиСерии,
																			|ИспользоватьКоличествоСерии,
																			|ИспользоватьНомерКИЗГИСМСерии,
																			|ИспользоватьRFIDМеткиСерии,
																			|ИспользоватьДатуПроизводстваСерии,
																			|ИспользоватьПроизводителяЕГАИССерии,
																			|ИспользоватьПроизводителяВЕТИССерии,
																			|ИспользоватьИдентификаторПартииВЕТИССерии,
																			|ИспользоватьЗаписьСкладскогоЖурналаВЕТИССерии,
																			|ИспользоватьСправку2ЕГАИССерии,
																			|ТочностьУказанияСрокаГодностиСерии");
								
	СтруктураВозврата.Вставить("ВидНоменклатуры",ВидНоменклатуры);
	СтруктураВозврата.Вставить("ФорматнаяСтрокаСрокаГодности");
	
	СтруктураВозврата.ФорматнаяСтрокаСрокаГодности =  ФорматнаяСтрокаСрокаГодности(СтруктураВозврата.ТочностьУказанияСрокаГодностиСерии);
	
	Возврат СтруктураВозврата;
КонецФункции

// Процедура возвращает форматную строку представления срока годности.
// Параметры:
//		СТочностьюДоЧасов - нужно ли в сроке годности указывать часы.
Функция ФорматнаяСтрокаСрокаГодности(ТочностьУказанияСрокаГодности)Экспорт
	Если ТочностьУказанияСрокаГодности = Перечисления.ТочностиУказанияСрокаГодности.СТочностьюДоЧасов Тогда
		ФорматнаяСтрока = "ДФ='dd.MM.yy-HH'";
	Иначе
		ФорматнаяСтрока = "ДФ=dd.MM.yy";
	КонецЕсли;
	
	Возврат ФорматнаяСтрока;
КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

Функция ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии(Событие) Экспорт
	
	//Событие: СохранениеРезультатов,ОткрытиеФормыРедактирования
	
	ИменаРеквизитов = "ИспользоватьRFIDМеткиСерии,ИспользоватьНомерКИЗГИСМСерии,ИспользоватьНомерСерии,ИспользоватьСрокГодностиСерии,"
					  +	"ТочностьУказанияСрокаГодностиСерии,НастройкаИспользованияСерий,ИспользоватьВидКИЗГИСМСерии,СрокГарантии,"
					  +	"АлкогольнаяПродукция, АвтоматическиГенерироватьСерии, ИспользоватьДатуПроизводстваСерии,"
					  +	"ИспользоватьПроизводителяЕГАИССерии, ИспользоватьСправку2ЕГАИССерии";

	Если Событие = "ОткрытиеФормыРедактирования" Тогда
		ИменаРеквизитов = ИменаРеквизитов + ",КиЗГИСМ,ПродукцияМаркируемаяДляГИСМ"
	КонецЕсли;
	
	Возврат ИменаРеквизитов;
	
КонецФункции

//	Параметры:
//			ВидНоменклатуры    - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, параметры серий которого которой нужно получить
//			СкладПодразделение - СправочникСсылка.Склады, СправочникСсылка.СтруктураПредприятия - склад или производственное подразделение
//									для которого нужно получить настройки серий. Если значение не задано - возвращаются настройки, которые
//									от склада не зависят
//	Возвращаемое значение:
//		Структура - структура с ключами:
//			* ВидНоменклатуры
//			* ИспользоватьСерии
//			* ИспользоватьНомерСерии
//			* ИспользоватьСрокГодностиСерии
//			* ИспользоватьКоличествоСерии
//			* ТочностьУказанияСрокаГодностиСерии
//			* ШаблонРабочегоНаименованияСерии
//			* ВладелецСерий
//			* НастройкиСерийБерутсяИзДругогоВидаНоменклатуры
//			* ШаблонЭтикеткиСерии
//			* ФорматнаяСтрокаСрокаГодности
//			* ОбязательныеДопРеквизиты
//			* ПолитикаУчетаСерий
//			* УказыватьПриПоступлении
//			* УказыватьПриОтгрузке
//			* УказыватьПриПланированииОтгрузки
//			* УчетСерийПоFEFO
//			* УказывыватьПоФактуОтбора
//			* УчитыватьОстаткиСерий
//			* УчитыватьСебестоимостьПоСериям
//
Функция НастройкиИспользованияСерий(ВидНоменклатуры, Магазин = Неопределено) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ВидНоменклатуры");
	Результат.Вставить("ИспользоватьСерии");
	Результат.Вставить("ИспользоватьНомерСерии");
	Результат.Вставить("ИспользоватьСрокГодностиСерии");
	Результат.Вставить("ИспользоватьКоличествоСерии");
	Результат.Вставить("ТочностьУказанияСрокаГодностиСерии");
	Результат.Вставить("ИспользоватьRFIDМеткиСерии");
	Результат.Вставить("ИспользоватьНомерКИЗГИСМСерии");
	
	Результат.Вставить("ФорматнаяСтрокаСрокаГодности");
	Результат.Вставить("ОбязательныеДопРеквизиты");
	
	Результат.Вставить("ПолитикаУчетаСерий");
	Результат.Вставить("УказыватьПриПоступлении");
	Результат.Вставить("УказыватьПриОтгрузке");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыНоменклатуры.Ссылка КАК ВидНоменклатуры,
	|	ВидыНоменклатуры.ИспользоватьСерии КАК ИспользоватьСерии,
	|	ВидыНоменклатуры.ИспользоватьНомерСерии КАК ИспользоватьНомерСерии,
	|	ВидыНоменклатуры.ИспользоватьСрокГодностиСерии КАК ИспользоватьСрокГодностиСерии,
	|	ВидыНоменклатуры.ИспользоватьКоличествоСерии КАК ИспользоватьКоличествоСерии,
	|	ВидыНоменклатуры.ТочностьУказанияСрокаГодностиСерии КАК ТочностьУказанияСрокаГодностиСерии,
	|	ВидыНоменклатуры.ИспользоватьRFIDМеткиСерии КАК ИспользоватьRFIDМеткиСерии,
	|	ВидыНоменклатуры.ИспользоватьНомерКИЗГИСМСерии КАК ИспользоватьНомерКИЗГИСМСерии,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий, ЗНАЧЕНИЕ(Справочник.ПолитикиУчетаСерий.ПустаяСсылка)) КАК ПолитикаУчетаСерий,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке, ЛОЖЬ) КАК УказыватьПриПоступлении,
	|	ЕСТЬNULL(ТЧПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузке, ЛОЖЬ) КАК УказыватьПриОтгрузке
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ТЧПолитикиУчетаСерий
	|		ПО ВидыНоменклатуры.Ссылка = ТЧПолитикиУчетаСерий.Ссылка
	|			И (ТЧПолитикиУчетаСерий.Магазин = &Магазин)
	|ГДЕ
	|	ВидыНоменклатуры.Ссылка = &ВидНоменклатуры";
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыШапки = РезультатЗапроса[0].Выбрать();
	РеквизитыШапки.Следующий();
	
	ЗаполнитьЗначенияСвойств(Результат, РеквизитыШапки);
	Результат.ФорматнаяСтрокаСрокаГодности = ФорматнаяСтрокаСрокаГодности(Результат.ТочностьУказанияСрокаГодностиСерии);
		
	Возврат Результат;
	
КонецФункции


#КонецОбласти

#КонецЕсли
