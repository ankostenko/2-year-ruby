require_relative 'notebook_handler'
require_relative 'input_handlers'
require_relative 'person'

module Notebook
  # parses input of user and determine which
  # command user wants to execute
  class Core
    def initialize
      @notebook = Input.read_file
      @options = {
        'remove' => :remove,
        'add' => :add,
        'caddress' => :ch_address,
        'cphone' => :ch_phone,
        's surname' => :sort_by_surname,
        's status'     => :sort_by_status,
        'event'        => :event,
        'exit'         => :exit,
        'show'         => :show
      }
      show
    end

    def run
      loop do
        print '> '
        line = gets
        break if line.nil?

        method = @options[line.strip]
        break if method == 'exit'
        if method.nil?
          puts 'Unknown command, try again'
        else
          send(method)
        end
      end
    end

    private

    def add
      name = Input.string_input('Name: ')
      surname = Input.string_input('Surname: ')
      patr = Input.string_input('Patronymic: ')
      cell_phone = Input.num_input('Cell phone: ')
      home_phone = Input.num_input('Home phone: ')
      address = Input.string_input('Address(<Street> <Number of house>): ')
      status = Input.string_input('Status: ')
      person = Person.new(name, surname, patr, # nil, nil, nil, status)
                          cell_phone, home_phone, address, status)
      @notebook.add(person)
    end

    def remove
      name = Input.string_input('Name: ')
      surname = Input.string_input('Surname: ')
      patr = Input.string_input('Patronymic: ')
      person = Person.new(name, surname, patr, nil, nil, nil, nil)
      @notebook.remove(person)
    end

    def ch_address
      name = Input.string_input('Name: ')
      surname = Input.string_input('Surname: ')
      patr = Input.string_input('Patronymic: ')
      new_address = Input.string_input('New address(<Street> <House number>): ')
      @notebook.change_address(name, surname, patr, new_address)
    end

    def ch_phone
      name = Input.string_input('Name: ')
      surname = Input.string_input('Surname: ')
      patr = Input.string_input('Patronymic: ')
      new_phone = Input.num_input('New phone: ')
      @notebook.change_phone(name, surname, patr, new_phone)
    end

    def sort_by_surname
      @notebook.sort { |p1, p2| p1.surname <=> p2.surname }
      show
    end

    def sort_by_status
      @notebook.sort { |p1, p2| p1.status <=> p2.status }
      show
    end

    def event
      event_name = Input.string_input('Name of event: ')
      status = Input.string_input('Status: ')
      invited = @notebook.event(status)
      invited.each do |person|
        file_work(person) 
      end
    end

    def file_work(person)
        file_name = person.name + '_' + person.surname + '_' + person.patronymic
        file = File.new(file_name, "w")  
        name_of_person = person.name + ' ' + person.surname + ' ' + person.patronymic
        app = Input.string_input('Add home address[y/n]?: ')
        if app.downcase == 'y'
          file.write(person.address + "\n")
        end
        file.write(name_of_person + "\n")
        puts name_of_person
        message = Input.string_input('Message: ')
        file.write(message)
        file.close
    end

    def show
      @notebook.each { |person| puts person }
    end
  end
end