import argparse


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
    parser.add_argument('--max_records', type=int, help='Количество объявлений', default=20)
    return parser.parse_args()

if __name__ == "__main__":
    args = get_argpars()
