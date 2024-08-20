﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ТипыАдресныхОбъектовДляРаспознаванияАдреса() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УровниСокращенийАдресныхСведений.Сокращение КАК Сокращение
		|ИЗ
		|	РегистрСведений.УровниСокращенийАдресныхСведений КАК УровниСокращенийАдресныхСведений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		АдресныеСокращения = РегистрыСведений.АдресныеОбъекты.АдресныеСокращения();
	Иначе
		АдресныеСокращения = РезультатЗапроса.Выгрузить(); 
	КонецЕсли;
	
	АдресныеСокращения.Колонки.Добавить("Длина", ОбщегоНазначения.ОписаниеТипаЧисло(3));
	АдресныеСокращения.Колонки.Добавить("СокращениеВНачале", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	АдресныеСокращения.Колонки.Добавить("СокращениеВКонце", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	
	Для каждого ЭлементИзПеречня Из АдресныеСокращения Цикл
		ЭлементИзПеречня.СокращениеВНачале = ВРег(ЭлементИзПеречня.Сокращение) + " ";
		ЭлементИзПеречня.СокращениеВКонце = " " + ВРег(ЭлементИзПеречня.Сокращение);
		ЭлементИзПеречня.Длина = СтрДлина(ЭлементИзПеречня.Сокращение);
	КонецЦикла;
	
	АдресныеСокращения.Свернуть("Длина, СокращениеВНачале, СокращениеВКонце");

	АдресныеСокращения.Индексы.Добавить("Длина");
	АдресныеСокращения.Сортировать("Длина Убыв");
	
	Возврат АдресныеСокращения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// HTTPСоединение для вызова веб-сервиса 1С.
//
// Возвращаемое значение:
//     HTTPСоединение - объект для вызовов сервиса.
//
Функция СервисКлассификатора1С(ВремяОжидания = 120) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Авторизация = АдресныйКлассификаторСлужебный.ПараметрыАутентификацииНаСайте();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Авторизация = Неопределено Тогда
		ИмяПользователя    = "неавторизованный";
		ПарольПользователя = "";
	Иначе
		ИмяПользователя    = Авторизация.Логин;
		ПарольПользователя = Авторизация.Пароль;
	КонецЕсли;
	
	СтруктураURIВебСервиса = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресныйКлассификаторСлужебный.АдресВебСервисаКонтактнойИнформации());
	ИмяСервера = СтруктураURIВебСервиса.ИмяСервера;
	
	Порт = ?(ЗначениеЗаполнено(СтруктураURIВебСервиса.Порт), СтруктураURIВебСервиса.Порт, Неопределено);
	Прокси = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		Прокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURIВебСервиса.Схема);
	КонецЕсли;

	ЗащищенноеСоединение         = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	ИспользоватьАутентификациюОС = Ложь;
	
	СохраненныйТекущийURLВебСервиса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АдресныйКлассификатор", "URLСервисаКлассификатора1С");
	Если ТипЗнч(СохраненныйТекущийURLВебСервиса) = Тип("Строка") И ЗначениеЗаполнено(СохраненныйТекущийURLВебСервиса) Тогда
		URLВебСервисаПоЧастям = СтрРазделить(СохраненныйТекущийURLВебСервиса, ":", Ложь);
		ИмяСервера = СокрЛП(URLВебСервисаПоЧастям[0]);
		Если URLВебСервисаПоЧастям.Количество() > 1 Тогда
			ТипЧисло = Новый ОписаниеТипов("Число");
			Порт = ТипЧисло.ПривестиЗначение(URLВебСервисаПоЧастям[1]);
			ЗащищенноеСоединение = Неопределено;
			Если Порт = 0 Тогда
				Порт = 80;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	
	Попытка
			
			Соединение = Новый HTTPСоединение(
				ИмяСервера,
				Порт,
				ИмяПользователя,
				ПарольПользователя,
				Прокси,
				ВремяОжидания,
				ЗащищенноеСоединение,
				ИспользоватьАутентификациюОС);
			
			Сервер = Соединение.Сервер;
			Порт   = Соединение.Порт;
			
	Исключение
		
		ШаблонЗапроса = "%1:%2%3ping";
		СсылкаНаРесурс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗапроса, ИмяСервера, Порт,
			АдресныйКлассификаторСлужебный.ПрефиксВерсииЗапроса());
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
			           |по причине:
			           |%3'"),
			Сервер, Формат(Порт, "ЧГ="),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
			МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
			РезультатДиагностики = МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(СсылкаНаРесурс);
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
				           |Результат диагностики:
				           |%2'"),
				РезультатДиагностики.ОписаниеОшибки);
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(АдресныйКлассификаторСлужебный.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

Функция СведенияОЗагрузкеСубъектовРФ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Соответствие;
	
	// Веб-сервис 1С
	СервисРезультат = АдресныйКлассификаторСлужебный.ВерсияПоставщикаДанных();
	КлассификаторДоступен = (СервисРезультат.Данные = Истина);
	Результат.Вставить("КлассификаторДоступен", КлассификаторДоступен);
	
	ИспользоватьЗагруженные = Ложь;
	ЕстьЗагруженныеСведения = Ложь;
	
	СведенияОЗагрузкеСубъектовРФ = АдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	Для каждого СведенияОбСубъектеРФ Из СведенияОЗагрузкеСубъектовРФ Цикл
		
		ЗагруженныеСведенияРегионаАктуальны = СведенияОбСубъектеРФ.Загружено;
		
		Если КлассификаторДоступен И СведенияОбСубъектеРФ.Устарело = Истина Тогда
			ЗагруженныеСведенияРегионаАктуальны = Ложь;
		КонецЕсли;
		
		Если СведенияОбСубъектеРФ.Загружено Тогда
			ЕстьЗагруженныеСведения = Истина;
		КонецЕсли;
		
		Если ЗагруженныеСведенияРегионаАктуальны Тогда
			ИспользоватьЗагруженные = Истина;
		КонецЕсли;
		
		Сведения = Новый Структура();
		Сведения.Вставить("ИспользоватьЗагруженные", ЗагруженныеСведенияРегионаАктуальны);
		Сведения.Вставить("ДатаЗагрузки", СведенияОбСубъектеРФ.ДатаЗагрузки);
		Результат.Вставить(СведенияОбСубъектеРФ.КодСубъектаРФ, Сведения);
		
	КонецЦикла;
	
	Результат.Вставить("ИспользоватьЗагруженные", ИспользоватьЗагруженные);
	Результат.Вставить("ЕстьЗагруженныеСведения", ЕстьЗагруженныеСведения);
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает является ли источником данных веб сервис.
//
// Возвращаемое значение:
//     Булево - если веб сервис является источником адресных сведений, то возвращает Истина.
//
Функция ИсточникДанныхАдресногоКлассификатораВебСервис() Экспорт
	
	СервисРезультат = АдресныйКлассификаторСлужебный.ВерсияПоставщикаДанных();
	Возврат СервисРезультат.Данные = Истина;
	
КонецФункции

Функция НаименованиеВладенийИСтроений() Экспорт
	
	Результат = Новый Структура("Владения, Строения", Новый Соответствие, Новый Соответствие);
	Результат.Владения.Вставить(0, "Дом");
	Результат.Строения.Вставить(0, "Строение");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СлужебныеАдресныеСведения.Тип КАК Тип,
		|	СлужебныеАдресныеСведения.Идентификатор КАК Идентификатор,
		|	СлужебныеАдресныеСведения.Ключ КАК Ключ,
		|	СлужебныеАдресныеСведения.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.СлужебныеАдресныеСведения КАК СлужебныеАдресныеСведения
		|ГДЕ
		|	СлужебныеАдресныеСведения.Тип = ""ESTSTAT""
		|			ИЛИ СлужебныеАдресныеСведения.Тип = ""STRSTAT""";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Если РезультатЗапроса.Тип = "ESTSTAT" Тогда
			Результат.Владения.Вставить(РезультатЗапроса.Идентификатор, РезультатЗапроса.Значение);
		ИначеЕсли РезультатЗапроса.Тип = "STRSTAT" Тогда
			Результат.Строения.Вставить(РезультатЗапроса.Идентификатор, РезультатЗапроса.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Параметры:
//  НаименованиеРегиона  - Строка - полное наименование региона
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//    * Загружен - Булево
//    * Устарел - Булево
//    * КодСубъектаРФ - Число
//
Функция СведенияОРегионе(Знач НаименованиеРегиона)  Экспорт
	
	Результат = АдресныйКлассификаторСлужебный.СведенияОЗагруженномРегионе();
	
	СведенияОРегионе = АдресныйКлассификаторСлужебный.НаименованиеИСокращение(НаименованиеРегиона, Истина);
	РезультатЗапроса = АдресныйКлассификаторСлужебный.АктуальныеДанныеОРегионе(СведенияОРегионе);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		АдресныйКлассификаторСлужебный.ВыполнитьНачальноеЗаполнение();
		РезультатЗапроса = АдресныйКлассификаторСлужебный.АктуальныеДанныеОРегионе(СведенияОРегионе);
		
		Если РезультатЗапроса.Пустой() Тогда
			
			КодСубъектаРФ = СписокРегионов().Получить(ВРег(НаименованиеРегиона));
			Если КодСубъектаРФ <> Неопределено Тогда 
				Результат.КодСубъектаРФ = КодСубъектаРФ;
			ИначеЕсли СтрСравнить(НаименованиеРегиона, 
				АдресныйКлассификаторСлужебный.ДействующиеНаименованиеКемеровскойОбласти()) = 0 Тогда
					Результат.КодСубъектаРФ = 42;
			Иначе
				АдресныйКлассификаторСлужебный.ПроверкаНаУстаревшийРегион(Результат, СведенияОРегионе);
			КонецЕсли;
			
			Возврат Новый ФиксированнаяСтруктура(Результат);
			
		КонецЕсли;
	КонецЕсли;
	
	ИнформацияОРегионе = РезультатЗапроса.Выбрать();
	
	Если ИнформацияОРегионе.Следующий() Тогда
		Результат.Загружен = ИнформацияОРегионе.РегионЗагружен;
		Результат.КодСубъектаРФ = ИнформацияОРегионе.КодСубъектаРФ;
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);

КонецФункции

Функция СписокРегионов() Экспорт
	
	Классификатор = РегистрыСведений.АдресныеОбъекты.КлассификаторСубъектовРФ();
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АдресныеОбъекты.КодСубъектаРФ КАК КодСубъектаРФ,
	|	АдресныеОбъекты.Наименование КАК Наименование,
	|	АдресныеОбъекты.Наименование + "" "" + АдресныеОбъекты.Сокращение КАК ПолноеНаименование
	|ИЗ
	|	РегистрСведений.АдресныеОбъекты КАК АдресныеОбъекты
	|ГДЕ
	|	АдресныеОбъекты.Уровень = 1";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(ВРег(ВыборкаДетальныеЗаписи.Наименование), ВыборкаДетальныеЗаписи.КодСубъектаРФ);
		Результат.Вставить(ВРег(ВыборкаДетальныеЗаписи.ПолноеНаименование), ВыборкаДетальныеЗаписи.КодСубъектаРФ);
		
		СтрокаВКлассификаторе = Классификатор.Найти(ВыборкаДетальныеЗаписи.КодСубъектаРФ, "КодСубъектаРФ");
		Если СтрокаВКлассификаторе <> Неопределено Тогда 
			Классификатор.Удалить(СтрокаВКлассификаторе);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого РегионИзКлассификатора Из Классификатор Цикл
		Результат.Вставить(ВРег(РегионИзКлассификатора.Наименование), РегионИзКлассификатора.КодСубъектаРФ);
		Результат.Вставить(ВРег(РегионИзКлассификатора.Наименование + " " + РегионИзКлассификатора.Сокращение), РегионИзКлассификатора.КодСубъектаРФ);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция СписокСокращений() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УровниСокращенийАдресныхСведений.Сокращение КАК Сокращение,
		|	УровниСокращенийАдресныхСведений.Уровень КАК Уровень,
		|	УровниСокращенийАдресныхСведений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.УровниСокращенийАдресныхСведений КАК УровниСокращенийАдресныхСведений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Результат.Вставить(Строка(ВыборкаДетальныеЗаписи.Уровень) + ВыборкаДетальныеЗаписи.Сокращение, 
			ВыборкаДетальныеЗаписи.Значение);
		КонецЦикла;
		
	Иначе
		
		АдресныеСокращения = РегистрыСведений.АдресныеОбъекты.АдресныеСокращения();
		Для Каждого ЭлементСокращение Из АдресныеСокращения Цикл
			Результат.Вставить(Строка(ЭлементСокращение.Уровень) + ЭлементСокращение.Сокращение,
				ЭлементСокращение.Наименование);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция АдресныеСокращенияПриказМинфинаРФ171н() Экспорт
	
	АдресныеСокращения = РегистрыСведений.АдресныеОбъекты.АдресныеСокращения();
	
	Результат = Новый Соответствие;
	
	Для каждого ЭлементИзПеречня Из АдресныеСокращения Цикл
		Результат.Вставить(ВРег(ЭлементИзПеречня.Наименование), ЭлементИзПеречня.СокращениеПриказаМинфинаРФ171н);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции


Функция МуниципальныеРайоны() Экспорт
	
	// АПК: 1297-выкл Данные адресного классификатора, не локализуются
	Результат = Новый Соответствие;
	Результат.Вставить("Г.О.", "Городской округ"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("М.Р-Н", "муниципальный район"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("ВН.ТЕР.", "Внутригородская территория"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("ВН.ТЕР.Г.", "Внутригородская территория"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("М.О.", "Муниципальный округ"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("МУН. ОКР.", "Муниципальный округ"); // @Non-NLS-1, @Non-NLS-2
	// АПК: 1297-вкл
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция Поселения() Экспорт
	
	// АПК: 1297-выкл Данные адресного классификатора, не локализуются
	Результат = Новый Соответствие;
	Результат.Вставить("Г.П.", "Городское поселение"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("Г. П.", "Городское поселение"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("ВН.Р-Н", "Внутригородской район"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("С.П.", "Сельское поселение"); // @Non-NLS-1, @Non-NLS-2
	Результат.Вставить("МЕЖ.ТЕР.", "Межселенная территория"); // @Non-NLS-1, @Non-NLS-2
	// АПК: 1297-вкл
	
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти
