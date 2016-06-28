"""Define reusable logging components"""

import logging

class RecordKeepingHandler(logging.NullHandler):
    """Store log records in a list"""
    def handle(self, record):
        """Store log records in a list"""
        self.record_list.append(record)

def make_record_keeping_logger(name=None, record_list=None):
    """Make a logger that silently stores log records in memory"""
    handler = RecordKeepingHandler()
    handler.record_list = []
    logger = logging.getLogger(name)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger

def make_instant_feedback_logger(name=None, fmt=None):
    """Make a logger that prints log records to the screen"""
    formatter = logging.Formatter(fmt)
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    logger = logging.getLogger(name)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger

