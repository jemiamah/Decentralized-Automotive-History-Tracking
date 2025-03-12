;; Accident Reporting Contract
;; Records incidents and insurance claims

(define-map reports
  { id: uint }
  {
    vin: (string-ascii 17),
    description: (string-ascii 100),
    severity: (string-ascii 10),
    reporter: principal,
    has-claim: bool
  }
)

(define-data-var last-id uint u0)

;; Report an accident
(define-public (report-accident
              (vin (string-ascii 17))
              (description (string-ascii 100))
              (severity (string-ascii 10))
              (has-claim bool))
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    ;; Update report counter
    (var-set last-id new-id)

    ;; Create the accident report
    (ok (map-set reports
      { id: new-id }
      {
        vin: vin,
        description: description,
        severity: severity,
        reporter: tx-sender,
        has-claim: has-claim
      }
    ))
  )
)

;; Get accident report
(define-read-only (get-report (id uint))
  (map-get? reports { id: id })
)

;; Get total reports count
(define-read-only (get-total-reports)
  (var-get last-id)
)

