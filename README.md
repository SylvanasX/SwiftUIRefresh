# SwiftUIRefresh

SwiftUIRefresh support async refresh

## Usage

```
struct ContentView: View {
    @State var numbers:[Int] = []
    let refreshController: RefreshController = RefreshController()
    var body: some View {
        RefreshNavigationView(title: "SwiftUIRefresh", refreshController: refreshController, action:{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.numbers = self.refreshNumbers()
                self.refreshController.endRefreshing()
            }
        }){
            ForEach(self.numbers, id: \.self){ number in
                VStack(alignment: .leading){
                    Text("\(number)")
                    Divider()
                }
            }
        }
        .onAppear {
            self.refreshController.beginRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.numbers = self.refreshNumbers()
                self.refreshController.endRefreshing()
            }
        }
    }
    
    func refreshNumbers() -> [Int] {
        var numbers = [Int]()
        for _ in 0...30 {
            numbers.append(Int.random(in: 0 ..< 1000))
        }
        return numbers
    }
}
```

## Installation

In Xcode got to File -> Swift Packages -> Add Package Dependency and paste inthe repo's url: https://github.com/SylvanasX/SwiftUIRefresh