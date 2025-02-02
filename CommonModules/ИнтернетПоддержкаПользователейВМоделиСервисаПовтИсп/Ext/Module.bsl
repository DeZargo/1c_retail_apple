﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа в модели сервиса.Базовая функциональность БИП".
// ОбщийМодуль.ИнтернетПоддержкаПользователейВМоделиСервисаПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция КлючОбластиДанных(ЗначениеРазделителя) Экспорт
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ЗначениеРазделителя);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Константы.КлючОбластиДанных.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти