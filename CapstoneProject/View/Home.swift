

import SwiftUI

struct Test: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        VStack {
            
            HeaderView()
         
            
            
            ZStack{
                
                
                HStack {
                    Text("Your Booked Classes")
                    Text("Your Upcoming Classes")
                    
                }
                
                
                
                
                
            }
            
            .frame(width: 330, height: 100)
            
            
            
    
            

            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                // MARK: Lazy Stack With Pinned Header
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        
                        // MARK: Current Week View
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10){
                                
                                ForEach(taskModel.currentWeek,id: \.self){day in
                                    
                                    VStack(spacing: 10){
                                        
                                        Text(taskModel.extractDate(date: day, format: "dd"))
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        
                                        // EEE will return day as MON,TUE,....etc
                                        Text(taskModel.extractDate(date: day, format: "EEE"))
                                            .font(.system(size: 14))
                                        
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 8, height: 8)
                                            .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                    }
                                    // MARK: Foreground Style
                                    .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
                                    .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    // MARK: Capsule Shape
                                    .frame(width: 45, height: 90)
                                    .background(
                                    
                                        ZStack{
                                            // MARK: Matched Geometry Effect
                                            if taskModel.isToday(date: day){
                                                Capsule()
                                                    .fill(.black)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                        }
                                    )
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        // Updating Current Day
                                        withAnimation{
                                            taskModel.currentDay = day
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        TasksView()
                        
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    // MARK: Tasks View
    func TasksView()->some View{
        
        LazyVStack(spacing: 20){
            
            if let tasks = taskModel.filteredTasks{
                
                if tasks.isEmpty{
                    
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                }
                else{
                    
                    ForEach(tasks){task in
                        TaskCardView(task: task)
                    }
                }
            }
            else{
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filterTodayTasks()
        }
    }
    
    // MARK: Task Card View
    func TaskCardView(task: Task)->some View{
        
        HStack(alignment: .top,spacing: 30){
            VStack(spacing: 10){
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                    
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack{
                
                HStack(alignment: .top, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if taskModel.isCurrentHour(date: task.taskDate){
                    
                    // MARK: Team Members
                    HStack(spacing: 0){
                        
                        HStack(spacing: -10){
                            
                            ForEach(["User1","User2","User3"],id: \.self){user in
                                
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                    
                                        Circle()
                                            .stroke(.black,lineWidth: 5)
                                    )
                            }
                        }
                    
                        
                        // MARK: Check Button
                        Button {
                            
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white,in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
           
            .background(
                Color("Black")
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
            )
        }
       
    }
    


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

}
