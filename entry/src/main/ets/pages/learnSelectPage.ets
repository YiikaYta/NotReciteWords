import router from '@ohos.router'
import { Word } from '../models/wordClass'
import { optionComponent } from './component/optionComponent'

@Entry
@Component
struct learnSelectPage {

  @State currentWords: Word[] = [
    new Word(
      { enValue: "Apple", cnValue: "苹果", type: "n" },
      { enValue: "An apple a day keeps the doctor away.", cnValue: "一天一个苹果，医生远离我。" },
      [
        { cnValue: "苹果", type: "名词" },
        { cnValue: "苹果公司", type: "专有名词" },
        { cnValue: "所有物", type: "名词" },
        { cnValue: "伐木作业", type: "名词" }],
      [
        { enValue: "apple pie", cnValue: "苹果派" },
        { enValue: "apple juice", cnValue: "苹果汁" }
      ]
    ),
    new Word(
      { enValue: "Banana", cnValue: "香蕉", type: "n" },
      { enValue: "Bananas are rich in potassium.", cnValue: "香蕉富含钾。" },
      [
        { cnValue: "香蕉", type: "名词" },
        { cnValue: "香蕉共和国", type: "专有名词" },
        { cnValue: "共和国", type: "专有名词" },
        { cnValue: "苹果", type: "名词" }
      ],
      [
        { enValue: "banana bread", cnValue: "香蕉面包" },
        { enValue: "banana split", cnValue: "香蕉船" }
      ]
    ),
  ]
  @State currentWord: Word = this.currentWords[0]
  // @State pointValue1
  @State points: Resource[] = [$r("app.media.point_inactive"), $r("app.media.point_inactive"), $r("app.media.point_inactive")]
  @State index: number = 0
  @State star: Resource = $r("app.media.star_inactive")
  @State starState: boolean = false
  @State isListVisible: boolean = true
  @State isNextVisible: boolean = false
  @State options: Array<{
    cnValue: string,
    type: string
  }> = []
  @State trueIndex: number = 0
  @State times: number = this.currentWord.correctTimes

  aboutToAppear() {
    this.InitWord()
  }

  build() {
    Column() {
      Row() {
        //返回按钮
        Button('<')
          .backgroundColor('#FFFFF')
          .fontColor(Color.Blue)
          .fontSize(30)
          .onClick(() => {
            router.back()
          })

        Text(`${this.index}` + '/10')
          .margin({ left: 30 })
          .fontSize(25)
        //收藏
        Image(this.star)
          .height(40)
          .width(40)
          .margin({ left: 30 })
          .onClick(() => {
            if (!this.starState) {
              this.star = $r("app.media.star_active")
            }
            else {
              this.star = $r("app.media.star_inactive")
            }
            this.starState = !this.starState
          })
        //删除
        Image($r("app.media.delete"))
          .height(30)
          .width(30)
          .margin({ left: 30 })
        //更多
        Image($r("app.media.more"))
          .height(30)
          .width(30)
          .margin({ left: 30 })

      }.margin({ top: 30 })

      Column() {
        Row() {
          Text(this.currentWord.word['enValue'])
            .height(80)
            .fontSize(50)
            .fontWeight(600)
            .margin({ left: 0, top: 60 })
          Column() {
            ForEach(this.points, (item) => {
              Image(item)
                .width(25)
                .height(10)
            },)
          }.margin({ top: 80 }).height(40)
        }.justifyContent(FlexAlign.Start).width('80%')

        Column() {
          Text(this.currentWord.word['type'] + '.' + this.currentWord.word['cnValue'])
            .fontSize(25)
        }.visibility(this.isNextVisible ? Visibility.Visible : Visibility.None).width('80%')
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 20 })

        Text('先回想词义再选择，想不起来[看答案]')
          .margin({ top: 30 }).visibility(this.isListVisible ? Visibility.Visible : Visibility.None)
      }.width('90%')

      Column({ space: 10 }) {
        Text(this.currentWord.exampleSentence['enValue'])
          .fontSize(20).margin({ left: 10 })
        Text(this.currentWord.exampleSentence['cnValue'])
          .fontSize(20).margin({ left: 10 })
      }
      .alignItems(HorizontalAlign.Start)
      .visibility(this.isNextVisible ? Visibility.Visible : Visibility.None)
      .width('80%')
      .backgroundColor("#EEFCFE")
      .margin({ top: 30 })
      .height('15%')
      .borderRadius(10)

      Column({ space: 10 }) {
        ForEach(this.currentWord.phrase, (item) => {
          Row() {
            Text(item['enValue'])
              .fontSize(20).margin({ left: 10 })
            Text(item['cnValue'])
              .fontSize(20).margin({ left: 20 })
          }.height(30)
        })
      }
      .alignItems(HorizontalAlign.Start)
      .visibility(this.isNextVisible ? Visibility.Visible : Visibility.None)
      .width('80%')
      .backgroundColor("#EEFCFE")
      .margin({ top: 30 })
      .height('30%')
      .borderRadius(10)

      List({ space: 30 }) {
        ForEach(this.options, (item, index) => {
          ListItem() {
            optionComponent({
              type: item['type'],
              cnValue: item['cnValue'],
              myIndex: index,
              trueIndex: this.trueIndex,
              isListVisible: $isListVisible,
              isNextVisible: $isNextVisible,
              correctTimes: $times,
              points: $points
            })
          }
        }, item => item['cnValue'] + '')
      }.width('80%').margin({ top: 60 })
      .visibility(this.isListVisible ? Visibility.Visible : Visibility.None)


      Text('看答案')
        .textAlign(TextAlign.Center)
        .margin({ top: 40 })
        .fontWeight(600)
        .fontSize(20)
        .visibility(this.isListVisible ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.isListVisible = false
          this.isNextVisible = true
        })
      Text('下一词')
        .textAlign(TextAlign.Center)
        .margin({ top: 40 })
        .fontWeight(600)
        .fontSize(20)
        .visibility(this.isNextVisible ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.isNextVisible = false
          this.isListVisible = true
          this.options = []
          this.index++
          this.InitWord()
        })
      Blank()
    }.width('100%').height('100%')
    .backgroundImage($r("app.media.backgroundImage"), ImageRepeat.NoRepeat)
    .backgroundImageSize(ImageSize.Cover)
  }

  generateUniqueIntegers(start: number, end: number): number[] {
    if (start > end) {
      throw new Error("Start must be less than or equal to end.");
    }

    // 创建一个包含指定范围内所有整数的数组
    const numbers: number[] = [];
    for (let i = start; i <= end; i++) {
      numbers.push(i);
    }

    // 洗牌算法，随机打乱数组中的元素
    for (let i = numbers.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [numbers[i], numbers[j]] = [numbers[j], numbers[i]]; // 交换元素
    }

    return numbers;
  }

  InitWord() {
    this.currentWord = this.currentWords[this.index]
    // console.info(`${this.currentWord}`)

    const uniqueIntegers = this.generateUniqueIntegers(0, 3);
    // console.info(`${uniqueIntegers}`)
    uniqueIntegers.forEach((value, index) => {
      if (value == 0) {
        this.trueIndex = index
      }
      // this.options[index] = this.currentWord.options[value]
      this.options.push(this.currentWord.options[value])
      // console.info(`${this.currentWord.options[index]['cnValue']}`)

    })

    // console.info(`${this.trueIndex}`)
    // console.info(`${this.options}`)
  }
}

// function InitWords(currentWords: Array<Word>) {
//   let params: object = router.getParams()
// }





