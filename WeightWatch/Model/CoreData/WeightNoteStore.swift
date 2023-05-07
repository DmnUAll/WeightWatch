//
//  WeightNoteStore.swift
//  WeightWatch
//
//  Created by Илья Валито on 07.05.2023.
//

import UIKit
import CoreData

// MARK: - WeightNoteStoreError
enum WeightNoteStoreError: Error {
    case decodingErrorInvalidUUID
    case decodingErrorInvalidDate
    case decodingErrorInvalidWeightChanges
}

// MARK: - WeightNoteStore
final class WeightNoteStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<WeightNoteCD>!

    var weightNotes: [WeightNote] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let notes = try? objects.map({ try self.getRecord(from: $0) })
        else { return [] }
        return notes
    }

    convenience override init() {
        let context = CoreDataManager.context
        // swiftlint:disable:next force_try
        try! self.init(context: context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = WeightNoteCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \WeightNoteCD.date, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }

    func addNewNote(_ weightNote: WeightNote) {
        let weightNoteCD = WeightNoteCD(context: context)
        updateExistingRecord(weightNoteCD, with: weightNote)
    }

    func updateExistingRecord(_ weightNoteCD: WeightNoteCD, with record: WeightNote) {
        weightNoteCD.id = record.id
        weightNoteCD.date = record.date
        weightNoteCD.weight = record.weightKG
        weightNoteCD.changesKG = record.changesKG
        try? context.save()
    }

    func deleteNote(_ note: WeightNote) {
        let request = NSFetchRequest<WeightNoteCD>(entityName: K.EntityNames.weightNoteCD)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        guard let note = try? context.fetch(request).first else { return }
        context.delete(note)
        try? context.save()
    }

    func getRecord(from weightNoteCD: WeightNoteCD) throws -> WeightNote {
        guard let weightNoteID = weightNoteCD.id else {
            throw WeightNoteStoreError.decodingErrorInvalidUUID
        }
        guard let weightNoteDate = weightNoteCD.date else {
            throw WeightNoteStoreError.decodingErrorInvalidDate
        }
        return WeightNote(id: weightNoteID,
                          weightKG: weightNoteCD.weight,
                          changesKG: weightNoteCD.changesKG,
                          date: weightNoteDate)
    }
}
