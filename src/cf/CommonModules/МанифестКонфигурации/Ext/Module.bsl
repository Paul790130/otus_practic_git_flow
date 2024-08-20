﻿
#Область ПрограммныйИнтерфейс

// Формирует манифест конфигурации (используется для декларации информации о конфигурации
// другим компонентам сервиса).
//
// Возвращаемое значение:
//	ОбъектXDTO - {http://www.1c.ru/1cFresh/Application/Manifest/a.b.c.d}ApplicationInfo.
// 
Функция СформироватьМанифестКонфигурации() Экспорт
	
	Манифест = ФабрикаXDTO.Создать(ТипМанифестКонфигурации());
	
	Манифест.Name = Метаданные.Имя;
	Манифест.Presentation = Метаданные.Синоним;
	Манифест.Version = Метаданные.Версия;
	Манифест.PlatformVersion = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности().МинимальноНеобходимаяВерсияПлатформы;
	
	РасширенныеСведения = Новый Массив();
	
	РаботаВМоделиСервисаБТС.ПриФормированииМанифестаКонфигурации(РасширенныеСведения);
	
	Для Каждого ЭлементСведений Из РасширенныеСведения Цикл
		ДопИнфо = Манифест.ExtendedInfo; // СписокXDTO
		ДопИнфо.Добавить(ЭлементСведений);
	КонецЦикла;
	
	Возврат Манифест;
	
КонецФункции

// Формирует манифест конфигурации, записывает его в файл и помещает двоичные данные файла во временное хранилище.
// Обертка над МанифестКонфигурации.СформироватьМанифестКонфигурации() для вызова из длительных
//  операций или из внешнего соединения.
//
// Параметры:
//  АдресХранилища - Строка - адрес во временном хранилище, по которому требуется поместить двоичные
//  	данные файла манифеста конфигурации.
//
Процедура ПоместитьМанифестКонфигурацииВоВременноеХранилище(Знач АдресХранилища) Экспорт
	
	Манифест = СформироватьМанифестКонфигурации();
	
	ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ВременныйФайл);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ПотокЗаписи, Манифест, , , , НазначениеТипаXML.Явное);
	ПотокЗаписи.Закрыть();
	
	ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл), АдресХранилища);
	
	УдалитьФайлы(ВременныйФайл);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипМанифестКонфигурации(Знач Пакет = Неопределено)
	
	Возврат СоздатьXDTOТип(Пакет, "ApplicationInfo");
	
КонецФункции

Функция ПакетМанифестаКонфигурации()
	
	Возврат "http://www.1c.ru/1cFresh/Application/Manifest/" + ВерсияМанифестаКонфигурации();
	
КонецФункции

Функция ВерсияМанифестаКонфигурации()
	
	Возврат "1.0.0.1";
	
КонецФункции

Функция СоздатьXDTOТип(Знач ИспользуемыйПакет, Знач Тип)
		
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = ПакетМанифестаКонфигурации();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти
