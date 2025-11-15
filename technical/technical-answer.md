1. **Describe the difference between module and class?**
Class can create Objects, modules cannot.
Modules can be included / extended into classes to add functionality.
example : Module Upload for utility that don't need instantiation. So any can be used on different file (sharing functionality)


2. **Describe the difference between the class variable and the class instance variable?**
Class variable: @@count 
Shared across the entire inheritance hierarchy
Class instance variable: @count
Parent has its own @count and Child has its own @count

3. **What is polymorphism and give an example for that in a model class?**
Polymorphism means 'many forms' — it lets different types of objects be treated uniformly through a common interface.
In my project, I use polymorphic associations in Rails. For example, the InsuranceClaim model can belong to either Core::Insurance or Core::InsuranceCorporateEmployee: 
```
class Core::InsuranceClaim
    belongs_to :insurance_service_able, polymorphic: true
end
```

4. **How do you handle N+1 performance issues?**
I handle N+1 query issues by using eager loading with .includes(). N+1 problems occur when you fetch a collection and then access an association for each record, causing 1 + N queries instead of just 2.

5. **Describe what is Lazy Load, and when to use it?**
Lazy loading means data is loaded only when it's actually accessed, not when the query is built. In Rails/Mongoid, this applies to both query execution and association loading.
```
# Query is built but NOT executed yet (lazy)
questions = Core::Question.where(picked_up_by_id: doctor_id)

# Query executes only when you access the data
questions.each do |q|  # ← Executes HERE
    puts q.title
end
```

6. **How to handle Unique Records in Concurrent Process?**
I handle unique records in concurrent processes using a Distributed locking (Redis Mutex)
```
mutex = RedisMutex.new(self.class.name)
return unless mutex.lock!  # Prevent concurrent execution
# ... critical section ...
ensure
    mutex&.unlock
end
```