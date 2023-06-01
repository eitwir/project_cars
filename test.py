import argparse
import csv
import re


# file_path = 'D:\DE\project_av\cars-av-by_card.csv'


def get_argpars():
    parser = argparse.ArgumentParser()
    parser.add_argument('--year_from', type=int, help='Год выпуска с', default=1900)
    parser.add_argument('--year_to', type=int, help='Год выпуска по', default=2023)
    parser.add_argument('--brand', type=str, help='Марка машины ', default='')
    parser.add_argument('--model', type=str, help='Модель машины', default='')
    parser.add_argument('--price_from', type=int, help='Год выпуска с', default='0')
    parser.add_argument('--price_to', type=int, help='Год выпуска по', default=None)
    parser.add_argument('--transmission', type=str, help='Тип коробки передач', default='')
    parser.add_argument('--milage', type=int, help='Максимальный пробег', default=None)
    parser.add_argument('--engine_from', type=int, help='Объём двигателя с', default=0)
    parser.add_argument('--engine_to', type=int, help='Объём двигателя по', default=None)
    parser.add_argument('--fuel', type=str, help='Тип топлива', default='')
    parser.add_argument('--exchange', type=str, help='Готовность совершить обмен', default='')
    parser.add_argument('--keywords', type=str, help='Ключевое слово', default='')
    parser.add_argument('--max_records', type=int, help='Количество объявлений', default=1000)
    return parser.parse_args()


def get_agree_about_exchange(csvfile):
    try:
        extr_agree_about_exchange = re.search(r"(\w+) (\w+),(\d{4})", csvfile)
    except AttributeError:
        extr_agree_about_exchange = re.search(r"(\w+) (\w+),(\d{4})", csvfile).group(0)
    return extr_agree_about_exchange


def get_data_from_csv(path, max_records):
    with open(path, newline='', encoding='utf-8') as csvfile:
        readit = csv.DictReader(csvfile, delimiter=',')
        for cnt, line in enumerate(readit):
            #brand = get_brand(line["title"])
            #model = get_model(line["title"], brand)
            #price = get_price(line["price_secondary"])[1:]
            # = get_year(line["description"])
            #transmission = get_transmission(line["description"])
            #milage = get_milage(line["description"])
            exchange = get_agree_about_exchange(line["exchange"])#engine = get_engine(line["description"])
            #uel = get_fuel(line["description"])
            print(f'{exchange}')
            # print(line["title"], f'{brand}')
            if cnt == max_records:
                break
        return


if __name__ == "__main__":
    args = get_argpars()
    get_data_from_csv("cars-av-by_card.csv", args.max_records)
    # get_model("cars-av-by_card.csv", extr_brand)
